title: DRAFT HPC & reproducible research in Guix 1.2.0
date: 2020-11-19 02:00:00
author: Simon Tournier
slug: hpc-reproducible-research-in-guix-1.2.0
tags: packages, releases
---

Version 1.2.0 of Guix was [announced
yesterday](https://guix.gnu.org/blog/2020/gnu-guix-1.2.0-released/).  As
the announcement points out, some 200 people contributed more than
10,000 commits since the previous release.  This post focuses on
important changes for HPC users, admins, and scientists made since
version 1.1.0 was released in April 2020.

# Reproducible science workflows

We’re giving users more flexibility on the command line, with the
addition of three [*package transformation
options*](https://guix.gnu.org/manual/en/html_node/Package-Transformation-Options.html):
`--with-debug-info` ([always debug in good
conditions](https://guix.gnu.org/manual/devel/en/html_node/Rebuilding-Debug-Info.html)!),
`--with-c-toolchain`, and `--without-tests`.  Consider this example:

```
guix build octave-cli \
  --with-c-toolchain=fftw=gcc-toolchain@10 \
  --with-c-toolchain=fftwf=gcc-toolchain@10
```

The command above builds a variant of the fftw and fftwf packages using
version 10 of gcc-toolchain instead of the default tool chain, and then builds
a variant of the GNU Octave command-line interface using them. GNU Octave
itself is also built with gcc-toolchain@10.

This other example builds the Hardware Locality (hwloc) library and its
dependents up to intel-mpi-benchmarks with the Clang C compiler:

```
guix build --with-c-toolchain=hwloc=clang-toolchain \
           intel-mpi-benchmarks
```

On the side of long-term archival of all the software Guix packages refer to,
Guix now serves the file [`sources.json`](http://guix.gnu.org/sources.json)
that is ingested by [Software Heritage](https://softwareheritage.org) via the
[nixguix
loader](https://docs.softwareheritage.org/devel/_modules/swh/loader/package/nixguix.html).
In addition to the “archival” check of `guix lint` which sends a “save”
request to Software Heritage for the specified packages.  More packages are
continuously archived.

The new option `--path` of [`guix
graph`](https://guix.gnu.org/manual/devel/en/html_node/Invoking-guix-graph.html),
shows the shortest path between two nodes.  The example below shows the
shortest path between the packages gmsh and cunit:

```
guix graph --path gmsh cunit
gmsh@4.6.0
metis@5.1.0
openblas@0.3.9
cunit@2.1-3

```

Moreover, the command [`guix
repl`](https://guix.gnu.org/manual/devel/en/html_node/Invoking-guix-repl.html)
can now be passed a script which ease [package exploratinon in
Guile](https://hpc.guix.info/blog/2020/01/reproducible-computations-with-guix/)
especially when dealing with the new Scheme `(guix transformation)` module for
package transformations.  And the section [“Programming
Interface”](https://guix.gnu.org/manual/devel/en/html_node/Programming-Interface.html)
of the *reference manual* has been greatly expounded.

The [`guix
pack`](https://guix.gnu.org/manual/devel/en/html_node/Invoking-guix-pack.html#Invoking-guix-pack)
command creates “application bundles” that can be used to deploy software on
machines that do not run Guix (yet!), such as HPC clusters. Since its
[inception in
2017](https://guix.gnu.org/blog/2017/creating-bundles-with-guix-pack/), it has
seen a number of improvements.  The relocatable packs can be now [faster by
the addition of the Fakechroot
engine](https://hpc.guix.info/blog/2020/05/faster-relocatable-packs-with-fakechroot/).


# Packages

Here are highlights among the 2,179 packages added and 4,487 packages
upgraded since the previous release:

 - [Gmsh](https://hpc.guix.info/package/gmsh) has been upgraded to 4.6.0.
 - [MPICH](https://hpc.guix.info/package/mpich) is now at 3.3.2.
 - [Open MPI](https://hpc.guix.info/package/openmpi) is now at 4.0.5.
 - [GCC](https://hpc.guix.info/package/gcc-toolchain) 10.2.0 is
    available and [LLVM, Clang](https://hpc.guix.info/package/clang-toolchain)
    11.0.0 too.
 - [Julia](https://hpc.guix.info/package/julia) has been upgraded to
    1.5.2.
 - [MPI4PY](https://hpc.guix.info/package/python-mpi4py) is at
    3.0.3.
 - For statisticians, there’s now a total of 1,488 R packages, many of
    which comes from [Bioconductor](https://www.bioconductor.org/) 3.11.

Last but not least, *the manual is fully translated* to
[French](https://guix.gnu.org/manual/fr/html_node/),
[German](https://guix.gnu.org/manual/de/html_node/), and
[Spanish](https://guix.gnu.org/manual/es/html_node/), with partial
translations in [Russian](https://guix.gnu.org/manual/ru/html_node/) and
[Chinese](https://guix.gnu.org/manual/zh-cn/html_node/).

Do not miss the [release
notes](https://guix.gnu.org/blog/2020/gnu-guix-1.2.0-released/) for more.

### Try it!

We want Guix to be accessible and useful to a broad audience and that
has again been a guiding principle for this release.  The [graphical
system
installer](https://guix.gnu.org/en/videos/system-graphical-installer/)
and the [script to install Guix on another
distro](https://guix.gnu.org/manual/en/html_node/Binary-Installation.html)
have both received bug fixes and usability improvements.  First-time
users will appreciate the fact that `guix help` now gives a clear
overview of the available commands, that `guix` commands are less
verbose by default, and that `guix pull` displays a progress bar as it
updates its Git checkout.

We’ve been told [you may soon be able to `apt install
guix`](https://packages.debian.org/guix) if you’re on Debian or a derivative
distro!—[get in touch with us](https://guix.gnu.org/en/contact/).

Enjoy the new release!
