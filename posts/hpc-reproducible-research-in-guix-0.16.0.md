title: HPC & reproducible research in Guix 0.16.0
author: Ludovic Courtès
date: 2018-12-07 13:30
slug: hpc-reproducible-research-in-guix-0-16-0
tags: packages, releases
---

Version 0.16.0 of Guix was [released
yesterday](https://guix.gnu.org/blog/2018/gnu-guix-and-guixsd-0.16.0-released/).
It’s slated to be the last release before 1.0, and as usual, it brings
noteworthy packages and features for HPC and reproducible research.

# Packages

Of the 985 packages were added and 1,945 upgraded, here are the
noteworthy HPC and bioinformatics changes:

  - [FEniCS](https://hpc.guix.info/package/fenics) and
    related packages were contributed by Paul Garlick of Tourbillion
    Technology.
  - [`petsc-openmpi`](https://hpc.guix.info/package/petsc-openmpi)
    is now configured with support for the HYPRE preconditioner, for
    the MUMPS solver, and for the HDF5 data format.
  - [SLEPc](https://hpc.guix.info/package/slepc) and
    [PETSc](https://hpc.guix.info/package/petsc) were
    upgraded to 3.10.1 and 3.10.2.
  - [MPI4Py](https://hpc.guix.info/package/python-mpi4py)
    was added.
  - [ngless](https://hpc.guix.info/package/ngless), a
    domain-specific language (DSL) for working with next generation
    sequencing data is now available.
  - A handful of packages for Nanopore processing have been added,
	including
	[Filtlong](https://hpc.guix.info/package/filtlong),
	[Nanopolish](https://hpc.guix.info/package/nanopolish),
	[Poretools](https://hpc.guix.info/package/poretools),
	and [Porechop](https://hpc.guix.info/package/porechop).
  - Hundreds of bioinformatics and R packages and upgrades were
    contributed in particular by Mădălin Ionel Patrașcu and Ricardo
    Wurmus of the Max Delbrück Center for Molecular Medicine (MDC).

# Reproducible scientific workflows

A lot of core Guix work has gone into improving tools in support of
reproducible development and deployment workflows—a prerequisite, in our
view, for reproducible research.

The new [_channels_
facility](https://guix.gnu.org/manual/en/html_node/Channels.html)
solves several problems:

  - It makes it easy to use a custom Guix, should you have specific
    needs.
  - It allows you to have [`guix
    pull`](https://guix.gnu.org/manual/en/html_node/Invoking-guix-pull.html)
    pull not just Guix, but also external package repositories such as
    [the HPC and bioinfo repositories of our
    institutes](https://hpc.guix.info/about/).
  - It allows you to _replicate_ a Guix setup with all its channels.
  
As an example, if I want to use packages from the [Guix-HPC repository
at Inria](https://gitlab.inria.fr/guix-hpc/guix-hpc), all I need to do
is create a `~/.config/guix/channels.scm` file containing this:

```scheme
;; Add Guix-HPC to the official Guix channel.
(cons (channel
        (name 'guix-hpc)
        (url "https://gitlab.inria.fr/guix-hpc/guix-hpc.git"))
      %default-channels)
```

From then on, `guix pull` will take care of pulling from both Guix and
Guix-HPC.

Previously you could already replicate Guix using `guix pull
--commit=XYZ` but integration with channels streamlines this.
Specifically, the new [`guix
describe`](https://guix.gnu.org/manual/en/html_node/Invoking-guix-describe.html)
command provides a complete description of the channels in use:


```sh
$ guix describe
Generation 23   Dec 07 2018 11:07:27    (current)
  guix 5118e26
    repository URL: https://git.savannah.gnu.org/git/guix.git
    branch: master
    commit: 5118e26f83cc2b4ec835df56bee2a4003c1325b9
  guix-hpc 779f4df
    repository URL: https://gitlab.inria.fr/guix-hpc/guix-hpc.git
    branch: master
    commit: 779f4df63892a95de6efba259abf82e64951d4be
```

Now let’s imagine Bob has a setup that works for him on his laptop and
wants to share it with Alice for use on a supercomputer.  Bob captures
his setup as a “pinned” channel specification in a file:

```sh
bob@laptop$ guix describe --format=channels > bob-channels.scm
```

He then sends `bob-channels.scm` over to Alice who, on the
supercomputer, feeds it to `guix pull`:

```sh
alice@supercomputer$ guix pull --channels=bob-channels.scm
Updating channel 'guix' from Git repository at 'https://git.savannah.gnu.org/git/guix.git'...
Updating channel 'guix-hpc' from Git repository at 'https://gitlab.inria.fr/guix-hpc/guix-hpc.git'...
Building from these channels:
  guix      https://git.savannah.gnu.org/git/guix.git   5118e26
  guix-hpc  https://gitlab.inria.fr/guix-hpc/guix-hpc.git       779f4df
…
```

Alice now has the exact same Guix as Bob, which in turn means she can
deploy the exact same pieces of software as Bob and yet have complete
provenance tracking of the binaries she runs—something “container
images” fail to provide.

The good thing with having access to all the package definitions is that
one can easily experiment with them, which is often a key aspect of
research work.  The [package transformation
options](https://guix.gnu.org/manual/en/html_node/Package-Transformation-Options.html)
should serve that need, and the new `--with-branch` and `--with-commit`
options that allow a package to be built straight from its Git
repository are another step in that direction.

Last but not least, Guix now supports [Software
Heritage](https://www.softwareheritage.org) as a back-end to fetch Git
repositories from.  That [makes Guix
resilient](https://issues.guix.info/issue/33432) to vanishing upstream
repositories, which is unfortunately not uncommon.  Along with
[reproducible builds](https://reproducible-builds.org/docs/definition/),
this secures reproducible software deployment from source to binaries.

Do not miss the [release
notes](https://guix.gnu.org/blog/2018/gnu-guix-and-guixsd-0.16.0-released/)
to learn about the other goodies that the release brings.

Enjoy the new release!
