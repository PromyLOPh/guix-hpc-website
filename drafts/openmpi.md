title: Optimized and portable Open MPI packaging
author: Ludovic Courtès
date: 2019-12-19 14:00
--

High-performance networks have constantly been evolving, in sometimes
hard-to-decipher ways.  Once upon a time, hardware vendors would
pre-install an MPI implementation (often an in-house fork of one of the
free MPI implementations) specially tailored for their hardware.
Fortunately, this time appears to be gone.  Despite that, there is still
widespread belief that MPI cannot be packaged in a way that achieves
best performance on a variety of contemporary high-speed networking
hardware.

This post is about our journey towards portable performance of [the
Open MPI package](http://hpc.guix.info/package/openmpi) in GNU Guix.
Spoiler: we reached that goal, but the road was bumpy.

# Portable performance in theory

Blissfully ignorant of the details and complexity of real life, the
author of this post initially thought that portable high-performance
networking with Open MPI was a solved problem.  Open MPI comes with
“drivers” (shared libraries) for all the major kinds of high-speed
networking hardware, and in particular various flavors of
[OpenFabrics devices](https://en.wikipedia.org/wiki/OpenFabrics_Alliance)
(including [InfiniBand](https://en.wikipedia.org/wiki/InfiniBand) or
“IB”) and [Omni-Path](https://en.wikipedia.org/wiki/Omni-Path) (by
Intel; abbreviated as “OPA”).  At run-time, Open MPI looks at the
available networking hardware, dynamically loads drivers that “match”,
and picks up “the best” match—or at least, that’s the goal.

The actual implementation of the networking primitives is left to
lower-level libraries.
[rdma-core](https://hpc.guix.info/package/rdma-core) provides the
venerable Verbs library (`libibverbs`), the historical driver for
InfiniBand hardware, typically hardware from around 2015, noted as
`mlx_4`.  [PSM](https://hpc.guix.info/package/psm) supports
the InfiniPath/TrueScale hardware sold by QLogic until some years ago.
[PSM2](https://hpc.guix.info/package/psm2) supports [Intel
Omni-Path](https://en.wikipedia.org/wiki/Omni-Path) hardware, the
successor of TrueScale.  Omni-Path is to be discontinued, according to
a July 2019 Intel announcement, and is still widely used, for example
[on the brand new Jean Zay
supercomputer](https://www.hpcwire.com/2019/01/22/france-to-deploy-ai-focused-supercomputer-jean-zay/).

Open MPI has interface to each of these.  Given the proliferation of
high-speed networks (many of which are variants of InfiniBand),
engineers had the idea to come up with unified programming interfaces,
with the idea that MPI implementations would use those interfaces
instead of talking directly to the lower-level drivers that we’ve seen
above.  [libfabric](https://hpc.guix.info/package/libfabric)
(aka. OpenFabrics or OFI) is _one of_ these “unified” interfaces—I guess
you can see the oxymoron, can’t you? :-) Libfabric actually bundles
Verbs, PSM, PSM2, and more, and provides an unique interface over them.
[UCX](https://hpc.guix.info/package/ucx) has a
similar “unification” goal, but with a different interface.  In addition
to the lower-level PSM, PSM2, and Verbs, Open MPI can use libfabric and
UCX _directly_, which in turn may drive a variety of networking
interfaces.

The abstraction level of all these interfaces is not quite the same,
because the level of hardware support differs among the different types
of network.  Thus, adding to this alphabet soup, Open MPI [defines these
categories](https://agullo-teach.gitlabpages.inria.fr/school/school2019/slides/mpi.pdf):

  - the _point-to-point management layer_ (PML) for high-level
    interfaces like UCX;
  - the _matching transport layer_ (MTL) for PSM, PSM2, and OFI;
  - the _byte transfer layer_ (BTL) for TCP, OpenIB, etc.

The general idea is that higher layers provide better performance on
supported hardware.

Still here?

So what does Open MPI do with all these drivers and meta-drivers?  Well,
if you build Open MPI will all these dependencies, Open MPI _picks up
the right driver_ at run time for your high-speed network.  Thus,
Open MPI is designed to support _performance portability_: you can have
a single Open MPI build (a single package) that will do the right thing
whether it runs on machines with Omni-Path hardware or on machines with
InfiniBand networking.  At least, that’s the theory…

# When reality gets in the way

How can one check whether practice matches theory?  It turns out to be
tricky because Open MPI, as of version 4.0.2, does not display the
driver and networking hardware that it chose.  Looking at `strace` or
`ltrace` logs for your Open MPI program won’t necessarily help either
because Open MPI may dlopen most or all the drivers, even if it just
picks one of them in the end.  Setting
`OMPI_MCA_mca_verbose=stderr,level:50` as an environment variable, or
something like `OMPI_MCA_pml_base_verbose=100` doesn’t quite help;
surely there must be some setting to get valuable debugging logs, but
the author was unable to find them.

One way to make sure you get the right performance for a given type of
network is to run, for example, the ping-pong benchmark of [the Intel
MPI benchmarks](https://hpc.guix.info/package/intel-mpi-benchmarks).
We’re lucky that our local cluster,
[PlaFRIM](https://www.plafrim.fr/en/), contains a heterogeneous set of
machines with different networking technologies: Omni-Path, TrueScale,
InfiniBand (`mlx4`), with some machines having both Omni-Path and
InifiniPath/TrueScale.  A perfect playground.  So we set out to test the `openmpi`
package of Guix on all these networks to confirm—so we thought!—that
we get the peak bandwidth and optimal latency for each of these:

```
# Here we ask SLURM to give us two Omni-Path nodes.
guix environment --pure --ad-hoc \
  openmpi openssh intel-mpi-benchmarks slurm -- \
  salloc -N 2 -C omnipath \
  mpirun -np 2 --map-by node IMB-MPI1 PingPong
```

And guess what: we’d get a much lower bandwidth than the expected
10 GiB/s (the theoretical peak bandwidth is 100 Gib/s, roughly 11 GiB/s
in practice).  You’d think you can force the use of PSM2 by passing `--mca
mtl psm2` to `mpirun` (this is the “MTL” we’ve seen above), but still,
that’s not enough to get the right performance.  Why is that?  Is PSM2
used at all?  Hard to tell.  A bit of trial and error shows that
explicitly disabling UCX with `--mca pml ^ucx` solves the problem and
gives us the expected 10 GiB/s peak bandwidth and a latency around 2 μs
for small messages.  We’re on the right track!

This is when we wonder:

  1. Why isn’t UCX giving the peak performance, [even though it claims
     to support
     Omni-Path](https://github.com/openucx/ucx/commit/113bae4b20d9bab3a7ece5cc9463c141182fad27)?
  2. Why is Open MPI selecting UCX if PSM2 does a better job on
     Omni-Path?
	 
The answer to question #1 is that UCX implements InfiniBand support,
which also happens to work on Omni-Path, only with sub-optimal
performance: PSM2 is the official high-performance driver while
InfiniBand is a poor standard-compliant mode.

To answer question #2, we need to take a closer look at Open MPI driver
selection method.  At run time, Open MPI dlopens all its transport
plugins.  It then asks each plugin ([_via_ its `init`
function](https://github.com/open-mpi/ompi/blob/master/ompi/mca/mtl/mtl.h#L70-L101))
whether it supports the available networking interfaces and filters out
those that don’t.  If there’s more than one transport plugin left, it
[picks the one _with the highest
priority_](https://github.com/open-mpi/ompi/blob/master/opal/mca/base/mca_base_components_select.c#L34).
Priorities can be changed on the command line; for instance, passing
`--mca pml_ucx_priority 20` sets the priority of UCX to 20.  Default
priorities
[are](https://github.com/open-mpi/ompi/blob/master/ompi/mca/mtl/psm2/mtl_psm2_component.c#L254)
[hard-coded](https://github.com/open-mpi/ompi/blob/master/ompi/mca/pml/ucx/pml_ucx_component.c#L52).
As it turns out, the UCX component has a higher priority than PSM2
claims to support Omni-Path, and thus takes precedence.  A similar
issue comes up with PSM.

# Getting the best performance

To achieve optimal performance by default on Omni-Path, TrueScale, and
InfiniBand networks, we thus had to [raise the default priority of the
PSM2
component](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=faab7082ab9587b71ca5ae8becdf72234f3c51d7)
and [that of the PSM
component](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=68ac34e1209c8ba631aea119a2a547f267a88576)
relative to that of the UCX component.

This wasn’t quite the end of the road, though.  PSM, [which is
apparently unmaintained](https://github.com/intel/psm), would segfault
at initialization time; [turning off its malloc statistics
feature](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=d8f8adfebf2c4040b7c04ff5e158ec664b92c268)
works around the problem.  TrueScale is old and the PSM component [will be gone in future
Open MPI versions
anyway](https://github.com/open-mpi/ompi/commit/0348d14ff3c081b4fe53f7aa3e3c6da93dc9773c)
so, assuming UCX works correctly on this hardware, this will not be a
problem anymore.

Finally, with these changes in place, we are able to get the optimal
performance on `mlx4`, InifiniPath, and Omni-Path networks on [our
cluster](https://www.plafrim.fr/en/).  We also checked on the
[GriCAD](https://gricad.univ-grenoble-alpes.fr/) and
[MCIA](https://www.mcia.univ-bordeaux.fr/projects/mcia) and confirmed
that we also achieve peak performance there.  The latter does not
provide Guix (yet!), so we built a Singularity image with [`guix
pack`](https://guix.gnu.org/manual/devel/en/html_node/Invoking-guix-pack.html):

```
guix pack -S /bin=bin -f squashfs bash \
  openmpi intel-mpi-benchmarks
```

… that we sent over to the cluster and run there, using the system’s
`salloc` and `mpirun` commands:

```
salloc -N2 mpirun -np 2 --map-by node -- \
  singularity exec intel-mpi-benchmarks.sqsh IMB-MPI1 PingPong
```

# Conclusions

We are glad that we were able to show that, with quite an effort, practice
matches theory—that we can get an Open MPI package that achieves optimal
performance for the available high-speed network interconnect.  We were
only able to test the three most common interconnects
available in the last years though, so we’d be happy to get your feedback if you’re
using a different kind of hardware!

There are other conclusions to be drawn.  First, we found it
surprisingly difficult to get feedback from Open MPI.  It would be
tremendously useful to have an easy way to have it display the transport
components that it selected and used when running an application.  As
far as default priorities go, it is hard to have a global picture and
ensure the various relative priorities all make sense.

The interconnect driver situation is a bit dire.  The coexistence of
vendor-provided drivers and “unified” interfaces adds to the confusion.
Efforts like UCX are a step in the right direction, but only insofar
that they manage to actually supersede the more specific
implementations—which is not yet the case, as we have seen with
Omni-Path.

The last conclusion is on the importance of joining forces on packaging
work.  Getting to an Open MPI package in Guix that performs well and in
a portable way has been quite a journey.  The result is now under
version control, available for all to use on their cluster, and
regressions can be tracked.  It is unreasonable to expect cluster admin
teams to perform the same work for their own cluster, in an ad-hoc
fashion, with a home-grown collection of
[modules](http://modules.sourceforge.net/).

# Acknowledgments
