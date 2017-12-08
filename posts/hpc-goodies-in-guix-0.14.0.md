title: HPC goodies in Guix 0.14.0
author: Ludovic Courtès
date: 2017-12-08 14:15
slug: hpc-goodies-in-guix-0-14-0
tags: packages, releases
---

Version 0.14.0 of Guix was [announced
yesterday](https://www.gnu.org/software/guix/blog/2017/gnu-guix-and-guixsd-0.14.0-released/).
In this post we look at the many goodies that made it into Guix during
this release cycle.

Over the 1,200+ packages added since the 0.13.0 release are many
noteworthy HPC additions.

Dave Love of the University of Manchester made a number of contributions
on the *high-performance networking* side:

  - Dave added
    [several](https://guix-hpc.bordeaux.inria.fr/package/opensm)
    [InfiniBand](https://guix-hpc.bordeaux.inria.fr/package/ibutils)
    [packages](https://guix-hpc.bordeaux.inria.fr/package/infiniband-diags),
    added [PSM](https://guix-hpc.bordeaux.inria.fr/package/psm) support
    in
    [libfabric](https://guix-hpc.bordeaux.inria.fr/package/libfabric).
  - [Open MPI](https://guix-hpc.bordeaux.inria.fr/package/openmpi)
    gained support for
    [RDMA](https://guix-hpc.bordeaux.inria.fr/package/rdma-core),
    libfabric, and PSM.
  - The [Intel MPI
    Benchmarks](https://guix-hpc.bordeaux.inria.fr/package/imb-openmpi)
    are now available as a package.
  - The size of the closure of the `openmpi` package with all its
    dependencies was [significantly
    reduced](https://debbugs.gnu.org/cgi/bugreport.cgi?bug=27905).  This
    is particularly appreciable if you’re [building application bundles
    with `guix
    pack`](https://guix-hpc.bordeaux.inria.fr/blog/2017/10/using-guix-without-being-root/).

The collection of *HPC profiling tools* has grown:

  - [PAPI](https://guix-hpc.bordeaux.inria.fr/package/papi);
  - [Score-P](https://guix-hpc.bordeaux.inria.fr/package/scorep-openmpi);
  - [otf2](https://guix-hpc.bordeaux.inria.fr/package/otf2);
  - [OPARI2](https://guix-hpc.bordeaux.inria.fr/package/opari2);
  - [CUBE](https://guix-hpc.bordeaux.inria.fr/package/cube).

*Linear algebra* packages have seen some changes:

  - [LAPACK](https://guix-hpc.bordeaux.inria.fr/package/lapack) was
    upgraded to 3.7.1, though 3.5.0 has been kept around for packages
    that are not ready for the latest API.
  - [Scotch](https://guix-hpc.bordeaux.inria.fr/package/scotch) is now
    built in 64-bit mode on 64-bit machines, and the new
    [`scotch32`](https://guix-hpc.bordeaux.inria.fr/package/scotch32)
    package provides a 32-bit version for applications that need it.
  - [BLIS](https://guix-hpc.bordeaux.inria.fr/package/blis) has been
    added.  Since it [does not support instruction set selection at
    run-time yet](https://github.com/flame/blis/issues/129), we created
    several packages specialized for each ISA extension:
    [`blis-haswell`](https://guix-hpc.bordeaux.inria.fr/package/blis-haswell)
    is the variant optimized for Haswell CPUs,
    [`blis-knl`](https://guix-hpc.bordeaux.inria.fr/package/blis-knl) is
    the KNL variant, and so on.  This is simplified by the
    implementation of a [high-level `make-blis` function that returns
    specialized
    packages](https://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/maths.scm#n2677).

As far as *numerical simulation* is concerned:

  - The [OpenFOAM](https://guix-hpc.bordeaux.inria.fr/package/openfoam)
    C++ computational fluid dynamics package was contributed by Paul
    Garlick of Tourbillion Technology.

There’s been a lot of activity in *bioinformatics*, leading to a total
of almost 300 bioinformatics packages, notably with the addition of the
following packages:

  - [f-seq](https://guix-hpc.bordeaux.inria.fr/package/f-seq);
  - [GEMMA](https://guix-hpc.bordeaux.inria.fr/package/gemma);
  - [GESS](https://guix-hpc.bordeaux.inria.fr/package/gess);
  - [Kallisto](https://guix-hpc.bordeaux.inria.fr/package/kallisto);
  - [kentutils](https://guix-hpc.bordeaux.inria.fr/package/kentutils);
  - [Ritornello](https://guix-hpc.bordeaux.inria.fr/package/ritornello);
  - many, many R packages (428 R package are available today).

Changes to *core Guix* relevant to HPC include:

  - `guix-daemon` gained the `--listen` command-line option that [we
    covered
    recently](https://guix-hpc.bordeaux.inria.fr/blog/2017/11/installing-guix-on-a-cluster/),
    and which is handy when installing Guix cluster-wide.
  - The new [`guix import
    json`](https://www.gnu.org/software/guix/manual/html_node/Invoking-guix-import.html)
    command provides a smooth way for newcomers to get started writing
    new package definitions.
  - aarch64 portability fixes were contributed by Eric Bavier of Cray,
    Inc.

Enjoy the new release!
