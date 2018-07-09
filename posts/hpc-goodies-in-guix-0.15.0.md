title: HPC goodies in Guix 0.15.0
author: Ludovic Courtès
date: 2018-07-06 16:00
slug: hpc-goodies-in-guix-0-15-0
tags: packages, releases
---

Version 0.15.0 of Guix was [released
today](https://www.gnu.org/software/guix/blog/2018/gnu-guix-and-guixsd-0.15.0-released/).
As usual, it brings packages and features that we hope HPC users and
sysadmins will enjoy.  This release brings us close to our goals for
1.0, so it’s probably one of the last zero-dot-something releases.

Over the 1,200+ packages added and 2,200+ packages updated since the
0.14.0 release, there are many noteworthy HPC additions.

  - [Open MPI](https://guix-hpc.bordeaux.inria.fr/package/openmpi) has
    been updated to 3.0.1.  It now comes with plugins for Intel
    OmniPath and Intel TrueScale _via_ the
    [PSM2](https://guix-hpc.bordeaux.inria.fr/package/psm2) and
    [PSM](https://guix-hpc.bordeaux.inria.fr/package/psm) packages.
  - [hwloc](https://guix-hpc.bordeaux.inria.fr/package/hwloc) 2.0 is now
    available alongside the 1.x series, which some applications such as
    [Slurm](https://guix-hpc.bordeaux.inria.fr/package/slurm) still
    require.
  - [fftw](https://guix-hpc.bordeaux.inria.fr/package/fftw) was upgraded
    to 3.3.7.  It is now built [with support for SIMD
    extensions](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=65bb22796f854cbc3eae053a80b1d64365dad376)
    selected at run-time, which addressed performance concerns we
    [discussed a while
    back](https://guix-hpc.bordeaux.inria.fr/blog/2018/01/pre-built-binaries-vs-performance/).
  - [superlu-dist](https://guix-hpc.bordeaux.inria.fr/package/superlu-dist)
    was upgraded to 5.3.0.
  - The [libpfm4](https://guix-hpc.bordeaux.inria.fr/package/libpfm4)
    performance monitoring library was added.
  - [Spindle](https://guix-hpc.bordeaux.inria.fr/package/spindle), a
    tool to improve the performance of dynamic library and Python module
    loading on HPC clusters, as well as the companion
    [LaunchMON](https://guix-hpc.bordeaux.inria.fr/package/launchmon)
    tool are now available, thanks to Pierre-Antoine Rouby who is
    currently working as an [intern at
    Inria](https://www.gnu.org/software/guix/blog/2018/guix-welcomes-outreachy-gsoc-and-guix-hpc-interns/).
  - OpenCL headers,
    [POCL](https://guix-hpc.bordeaux.inria.fr/package/pocl), and
    [Beignet](https://guix-hpc.bordeaux.inria.fr/package/beignet) were
    contributed by “Fis Trivial”, without support for the lock-in NVIDIA
    devices, but with support for modern Intel CPUs and GPUs.
  - Other noteworthy changes include the addition of
    [Elemental](https://guix-hpc.bordeaux.inria.fr/package/elemental)
    and [QD](https://guix-hpc.bordeaux.inria.fr/package/qd), as well as
    upgrades to
    [CERES](https://guix-hpc.bordeaux.inria.fr/package/ceres-solver) and
    [Eigen](https://guix-hpc.bordeaux.inria.fr/package/eigen), thanks to
    Eric Bavier of Cray, Inc.

There have been many changes among the several hundreds of
*bioinformatics* and statistics packages available in Guix and we won’t
list them here.  As part of the [work on reproducible bioinformatics
pipeline](https://guix-hpc.bordeaux.inria.fr/blog/2018/05/paper-on-reproducible-bioinformatics-pipelines-with-guix/),
Ricardo Wurmus of the Max Delbrück Center for Molecular Medicine
contributed lots of fixes enabling bit-reproducible builds of packages,
in particular Python and R packages.

Changes to *core Guix* relevant to HPC include:

  - The `guix pack` command can now produce [relocatable
    executables](https://www.gnu.org/software/guix/blog/2018/tarballs-the-ultimate-container-image-format/).
    The technique relies on _user namespaces_ so it’s unfortunately [not
    directly usable on some
    clusters](https://guix-hpc.bordeaux.inria.fr/blog/2017/09/reproducibility-and-root-privileges/).
    Nevertheless, it’s a simple and powerful way to distribute
    applications for use on non-Guix systems.
  - `guix pack` can now produce application bundles in the form of
    SquashFS images, thanks to Ricardo Wurmus.  These can in turn be
    executed by [Singularity](http://singularity.lbl.gov), a lightweight
    “container engine” that specifically targets HPC usage.
  - The [`guix pull`
    command](https://www.gnu.org/software/guix/manual/en/html_node/Invoking-guix-pull.html),
    which upgrades Guix and its package collection, now supports
    rollbacks (like `guix package`) and it has a new
    `--list-generations` option to visualize past upgrades.  This is
    probably a great user interface improvement to scientists who care
    about being able to reproduce and compare their software
    environments.
  - `guix-daemon` will now reject attempts to run `guix gc` from a
    remote node.  This is done such that, on [cluster
    installations](https://guix-hpc.bordeaux.inria.fr/blog/2017/11/installing-guix-on-a-cluster/),
    garbage collection can only be triggered from the master node, which
    is typically only accessible to sysadmins.  This was contributed by
    Roel Janssen of the Utrecht Bioinformatics Center.
  - Roel Janssen’s
    [hpcguix-web](https://guix-hpc.bordeaux.inria.fr/package/hpcguix-web),
    the web interface to browse packages that you can see [on this
    site](https://guix-hpc.bordeaux.inria.fr/browse), is now available
    [as a Guix system
    system](https://www.gnu.org/software/guix/manual/en/html_node/Web-Services.html#index-hpcguix_002dweb_002dservice_002dtype),
    thanks to the work of Pierre-Antoine Rouby at Inria.

That’s it for the HPC side of things.  Do not miss the [release
notes](https://www.gnu.org/software/guix/blog/2018/gnu-guix-and-guixsd-0.15.0-released/)
to learn about the other goodies that the release brings.

Enjoy the new release!
