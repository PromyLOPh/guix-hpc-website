title: Guix-HPC debut!
author: Ludovic Courtès, Roel Janssen, Pjotr Prins, Ricardo Wurmus
date: 2017-05-15 14:00
---

This post marks the debut of Guix-HPC, an effort to optimize
[GNU Guix](https://gnu.org/s/guix) for reproducible scientific workflows
in high-performance computing (HPC).  Guix-HPC is a joint effort between
[Inria](https://www.inria.fr/en), the
[Max Delbrück Center for Molecular Medicine (MDC)](https://www.mdc-berlin.de/),
and [UMC Utrecht](http://www.umcutrecht.nl/en/-1).  Ludovic Courtès,
Ricardo Wurmus, and Roel Janssen are driving the effort in each of these
institutes, each one focusing specific areas of interest within this
overall Guix-HPC effort.  Our institutes have in common that they are
users of HPC, and that, as scientific research institutes, they have an
interest in using reproducible methodologies for carry out their
research.

Our goals are really twofold: reproducible scientific workflows, and HPC
software deployment.  In this post we will describe what we hope to
achieve in the coming months in these areas.

# Reproducible scientific workflows

“[Reproducible research](https://en.wikipedia.org/wiki/Reproducible_research)”—something
that sounds like a pleonasm—is becoming more important.  More and more
experiments rely on computation and software, but relying on software
should not make these experiments non-reproducible.  Unfortunately that
has often been the case, but this is changing.  To give a few examples,
the US National Science Foundation (NSF) is now
[encouraging reproducibility in computing](https://www.nsf.gov/pubs/2017/nsf17022/nsf17022.jsp?WT.mc_id=USNSF_25&WT.mc_ev=click),
journals
[such as Nature](http://www.nature.com/ngeo/journal/v7/n11/full/ngeo2294.html)
insists of the importance of sharing source code and supporting
reproducibility, major conferences such as SuperComputing now have
[reproducibility guidelines](http://sc17.supercomputing.org/submitters/technical-papers/reproducibility-initiatives-for-technical-papers/),
and Inria’s upcoming
“[strategic plan](https://www.inria.fr/en/institute/strategy/strategic-plan)”
will have a chapter on reproducible science.

We believe that a prerequisite of reproducible science are _reproducible
software environments_.  Of course it takes more than reproducible
software environments to achieve reproducible scientific workflows—for
instance, reproducible numerical recipes and deterministic parallel
programs are crucial in HPC.

In fact there’s a whole spectrum of initiatives around reproducibility:
at one end of the spectrum, efforts like
[Software Heritage](https://softwareheritage.org) allow us to preserve
source code.  At the other end, there are efforts like
[ReScience](https://rescience.github.io), a peer-reviewed journal for
computational sciences where everyone can _replicate_ the computational
experiments.  Somewhere in the middle of the spectrum, projects such as
GNU Guix strive to support flexible and reproducible software
deployment, as we described in our
[2015 RepPar paper](https://hal.inria.fr/hal-01161771/en), _Reproducible
and User-Controlled Software Environments in HPC with Guix_.

In a nutshell, just like they are able to unambiguously refer to a
research article by its
[DOI](https://en.wikipedia.org/wiki/Digital_object_identifier),
researchers should be able to unambiguously refer to software artifacts.
Likewise, just like researchers should publish the data they rely on in
their articles so that their peers can assess and question their
work, they should publish the software that led to a particular result.
This necessity is particular acute in areas such as numerical simulation
or the development of run-time systems or compilers for HPC, since the
results that are published depend in large part on software.

# Containers to the rescue?

“Look, we have a solution!”, I hear you say.  “Just use containers!
[Docker](https://docker.com), [Singularity](http://singularity.lbl.gov),
[Shifter](http://www.nersc.gov/research-and-development/user-defined-images/),
you name it!”  It is true that “containers”, or, more accurately,
[“application bundles”](https://en.wikipedia.org/wiki/Application_bundle),
solve part of the reproducibility problem.  Without them, users would
build applications by themselves, and, inevitably, their software
environment would be vastly different from yours: different version of
the application, different compiler versions, different libraries,
different compilation options, and so on.  Conversely, an application
bundles contains all the software that you used, the _exact same bits_
that those you run on your machine.  In that sense, application bundles
get users a long way towards truly reproducible software environments.

As we jokingly illustrated in
[a talk at FOSDEM](https://fosdem.org/2017/schedule/event/hpc_deployment_guix/),
those app bundles are akin to shrink-wrapped computers: they include all
of the operating system and libraries that the application needs.  But
like shrink-wrapped computers, they’re inconvenient to deal with: you
can’t easily unwrap them and add another application in them—another
shrink-wrapped computer; you can’t easily unwrap them and experiment
with a specific component; if you do unwrap them, you still do not know
how they were built.

But is bit-for-bit reproducibility all that a researcher cares about?
Don’t researchers want to go _beyond_ reproducing the exact same bits?
Of course they do.  To pick a concrete example, one of the teams at
Inria develops [StarPU](http://starpu.gforge.inria.fr/), a run-time
system to schedule computational tasks on CPUs, GPUs, and accelerators.
The team next-door develops linear algebra software such as
[Chameleon](https://gitlab.inria.fr/solverstack/chameleon/) that relies
on StarPU to get good performance.  Researchers working on scheduling in
StarPU might want to fiddle with how Chameleon uses StarPU and see how
this affects performance; likewise, Chameleon developers might want to
fiddle with the scheduling algorithms StarPU uses to see if it could
work better for their workload.  This simple example illustrates the
need for tools that not only support reproducibility, but also _enable
experimentation_.

We believe that app bundles fall short on this requirement.  Conversely,
Guix supports both bit-for-bit reproducibility _and_ experimentation.
In Guix,
[package definitions](https://www.gnu.org/software/guix/manual/html_node/Defining-Packages.html)
express software composition in unambiguous terms.  Given a commit of
the [Guix repository](https://git.savannah.gnu.org/cgit/guix.git/),
anyone building a set of packages as defined in Guix will get _the exact
same result_, usually [bit-for-bit](https://reproducible-builds.org/).
Yet, Guix also allows users to define _package variants_, either
programmatically or
[from the command line](https://www.gnu.org/software/guix/manual/html_node/Package-Transformation-Options.html).
These properties get us closer to having both reproducible _and_
customizable software deployments.

# Software deployment on HPC systems

Perhaps at this point you’re thinking that this sounds interesting, but
that all you’ve ever seen when it comes to software deployment on HPC
systems is the venerable [“modules”](http://modules.sourceforge.net/)
tool set.  “Modules” provide a level of customization that’s greatly
appreciated on these big multi-user HPC systems: as a user you get to
choose which versions of the packages to load in your environment, and
you can have separate sessions using different packages and package
versions.  The downside is that modules rely on sysadmins to package the
software.  Thus, different machines may have different modules; modules
may vanish when sysadmins decide it—that could be on the day before the
deadline for your super-important paper; useful packages might be
missing a module; packages available as modules might be configured not
quite they way you’d like; and so on.  In other words, there’s a lack of
flexibility.

This problem has been recognized over the year by the HPC community.
The main answers to that, in addition to containers, which are still
mostly unavailable on HPC systems, has been to develop custom package
managers such as [EasyBuild](http://hpcugent.github.io/easybuild/) and
[Spack](https://github.com/LLNL/spack).  These tools are comparable to
standard package managers found on GNU/Linux (apt, yum, etc.), but they
are tailored for use by unprivileged HPC users.  Without being root on
the supercomputer, you can now build and install software package by
EasyBuild or Spack.  On top of that, these tools provide ways for you to
customize package recipes.  For example, Spack has
[many command-line and configuration options](https://spack.readthedocs.io/en/latest/build_settings.html)
allowing you to customize the build process—choosing the compiler that
is used, choosing the MPI or BLAS implementation, etc.

The main downside, this time, is that the very ability to use these
tools without root privileges hampers reproducibility.  Concretely, what
builds on one machine might fail to build on another one, as illustrated
by reports like
[this one](https://github.com/hpcugent/easybuild-easyconfigs/issues/638)
or
[that one](https://github.com/LLNL/spack/issues/2055#issuecomment-255560039).
It is the kind of discrepancy that Guix tries hard to avoid.  It runs
each build
[in isolated environments](https://www.gnu.org/software/guix/manual/html_node/Features.html)
where only the build’s inputs are accessible.  Unless the software or
its build procedure is non-deterministic, this ensures that a given
build process _produces the same result on any machine_.  In other
words, if I managed to build a package on my laptop, I can tell you you
can build the same package on your supercomputer and get the exact same
bits.  That’s a good property to have!

# Stay tuned!

Truth to be said, to our knowledge, Guix is currently deployed only on a
handful of supercomputers today: the MDC runs it, so does UMC Utrecht,
Inria’s research center in Bordeaux will deploy it on its cluster in the
coming months, and a look at the activity on the `guix-devel` mailing
list suggests that several other HPC deployments are actively used in
academic contexts.  There are several reasons why there aren’t more Guix
deployments on HPC clusters.  One of them is that Guix is only 4 years
old, and it was not specifically written as a tool for HPC and research
scientists—it just happens to have useful properties in this context.
The other reason is the fact that, to achieve build isolation,
[it relies on features of the kernel Linux](https://www.gnu.org/software/guix/manual/html_node/Invoking-guix_002ddaemon.html#Invoking-guix_002ddaemon)
usually only available to system administrators.

The Guix-HPC effort will attempt to address this, both through technical
means (more on that later), by discussing and raising awareness of
the reproducibility and deployment situation in the HPC community, and
by giving talks and running training sessions.  We
will also work on improving the user experience and workflows for
researchers using Guix with HPC and reproducibility in mind.

In future posts, we’ll first describe what the institutes involves in
Guix-HPC expect from this project, and how they take advantage of Guix.
We’ll also describe concrete actions we’ve identified to achieve these
goals.  So please stay tuned, and share your ideas, comments, and
criticism with us on the
[`guix-devel` mailing list](https://www.gnu.org/software/guix/about/#contact)!
If you are already using Guix and would like to join the effort, or if
you have questions about training sessions or deployment on your
cluster, please email us on the `guix-hpc@gnu.org` private alias.
