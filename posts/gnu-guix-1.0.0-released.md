title: GNU Guix 1.0: a solid foundation for HPC and reproducible science
author: Ludovic Courtès
date: 2019-05-06 17:00
slug: gnu-guix-1.0-foundation-for-hpc-reproducible-science
tags: packages, releases
---

GNU Guix 1.0.0 was
[released](https://www.gnu.org/software/guix/blog/2019/gnu-guix-1.0.0-released/)
just a few days ago!  This is a major milestone for Guix, which has
been under development for seven years, with more than 40,000 commits
made by 260 people, and no less than 19 “0.x” releases.

![Guix 1.0!](https://www.gnu.org/software/guix/static/blog/img/guix-1.0.png)

Useful links:

  - [installation script and
    instructions](https://www.gnu.org/software/guix/manual/en/html_node/Binary-Installation.html)
  - reference manual:
	[Deutsch](https://www.gnu.org/software/guix/manual/de/html_node),
    [English](https://www.gnu.org/software/guix/manual/en/html_node),
    [español](https://www.gnu.org/software/guix/manual/es/html_node),
    [français](https://www.gnu.org/software/guix/manual/fr/html_node)
  - [quick reference card](https://www.gnu.org/software/guix/guix-refcard.pdf)
	
More download options are [available on the Guix web
site](https://www.gnu.org/software/guix/download/).

# What GNU Guix can do for scientists and HPC practitioners

We think Guix 1.0 is a solid toolbox for scientists concerned about
reproducibility, for HPC practitioners, and also for cluster system
administrators.  We had outlined this vision in our 2015 paper,
[_Reproducible and User-Controlled Software Environments in HPC with
Guix_](https://hal.inria.fr/hal-01161771/en); 1.0 makes this a reality,
with a toolbox that goes beyond what we had envisioned back then.  Let
us summarize the salient features of Guix.

## For scientists

  - *Reproducibility* and *transparency.* Guix combines the flexibility
    and transparency of “package-centered” like
    [Anaconda](https://anaconda.org) or [Spack](https://spack.io), along
    with the reproducibility of “container-based solutions” such as
    [Docker](https://www.docker.com/) or
    [Singularity](https://www.sylabs.io/singularity/).
	
	With [`guix pull` and `guix
    describe`](https://guix-hpc.bordeaux.inria.fr/blog/2018/12/hpc-reproducible-research-in-guix-0-16-0/),
    you can reproduce the exact same environment on a different machine,
    or at a different point in time.  Our [collaboration with Software
    Heritage](https://www.softwareheritage.org/2019/04/18/software-heritage-and-gnu-guix-join-forces-to-enable-long-term-reproducibility/)
    aims to strengthen the ability to reproduce software environments in
    the long term.

  - *Packages.* No need to wait for cluster sysadmins to provide the
    software you’re interested in as
    [modules](http://modules.sourceforge.net/): almost [10,000
    packages](https://guix-hpc.bordeaux.inria.fr/browse) are one `guix
    install` command away, maintained openly by [an active
    community](https://www.openhub.net/p/gnuguix/), including lots of
    scientific software packages—from
    [OpenFOAM](https://guix-hpc.bordeaux.inria.fr/package/openfoam) and
    [TensorFlow](https://guix-hpc.bordeaux.inria.fr/package/tensorflow),
    to linear algebra software, and to statistics and bioinformatics
    packages.
	
	Upgrade software when _you_ decide, not when administrators decide,
    and have the assurance that you can _roll back_ any time.

  - *Flexibility.* Guix allows you to customize packages [directly from
    the command
    line](https://www.gnu.org/software/guix/manual/en/html_node/Package-Transformation-Options.html),
    or by using [its
    APIs](https://www.gnu.org/software/guix/manual/en/html_node/Defining-Packages.html).
    While a container image merely allows you to run the software as-is,
    Guix gives you the ability to inspect and modify the software you
    use.

## For developers

  - *Channels.*  With
    [channels](https://www.gnu.org/software/guix/manual/en/html_node/Channels.html),
    developers can publish their own package collection.  You can easily
    share package definitions for your software with colleagues and
    partners, while still benefiting from the properties of Guix.

  - *Container images.* You have a Guix-managed package collection and
    would like to use it on a cluster that lacks Guix?  Create an
    application bundle with [`guix
    pack`](https://guix-hpc.bordeaux.inria.fr/blog/2017/10/using-guix-without-being-root/),
    in the [Docker (OCI) or Singularity
    format](https://www.gnu.org/software/guix/manual/en/html_node/Invoking-guix-pack.html).

  - *Development environments.* With [`guix
    environment`](https://www.gnu.org/software/guix/manual/en/html_node/Invoking-guix-environment.html),
    set up a “clean” development environments for your software in one
    command.  If you’re used to [Conda
    environments](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html),
    you’ll find that this provides similar functionality,
    [except](https://github.com/conda/conda/issues/2997) that with Guix
    this is reproducible in time and space.

## For system administrators

  - *Relief from software packaging.*  Instead of providing
    [modules](http://modules.sourceforge.net), let users manage their
    own software environment and upgrade packages as they see fit.

  - *Garbage collection.*  No need to guess what software is in
    use—running [`guix
    gc`](https://www.gnu.org/software/guix/manual/en/html_node/Invoking-guix-gc.html)
    is all it takes to free space.

  - *Security.* The vast majority of Guix packages are
    [bit-reproducible](https://reproducible-builds.org/docs/definition/).
    You do _not_ need to [trust third-party
    binaries](https://www.gnu.org/software/guix/manual/en/html_node/On-Trusting-Binaries.html),
    and when you do, you can
    [challenge](https://www.gnu.org/software/guix/manual/en/html_node/Invoking-guix-challenge.html)
    them.

# Let’s get in touch!

Whatever your HPC or scientific use case is, we hope that you’ll find in
GNU Guix 1.0 the tools to further your goals.  We’d love to hear from
you!  You can email us at
[`guix-hpc@gnu.org`](https://guix-hpc.bordeaux.inria.fr/about/) or on
the Guix [mailing lists](https://www.gnu.org/software/guix/contact/).
