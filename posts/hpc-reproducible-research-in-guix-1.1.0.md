title: HPC & reproducible research in Guix 1.1.0
author: Ludovic Courtès
date: 2020-04-16 12:30
slug: hpc-reproducible-research-in-guix-1.1.0
tags: packages, releases
---

Version 1.1.0 of Guix was [announced
yesterday](https://guix.gnu.org/blog/2020/gnu-guix-1.1.0-released/).  As
the announcement points out, some 200 people contributed more than
14,000 commits since the previous release.  This post focuses on
important changes for HPC users, admins, and scientists made since
version 1.0.1 was released in May 2019.

# Reproducible science workflows

Here are some of the key improvements for the use of Guix as a tool for
reproducible science:

  - The new [`guix
    time-machine`](https://guix.gnu.org/manual/en/html_node/Invoking-guix-time_002dmachine.html)
    command makes it easy to “jump” back to a specific revision of Guix
    and reproduce _precisely_ a given software environment.  This is
    [key to supporting reproducible science
    workflows](https://hpc.guix.info/blog/2020/01/reproducible-computations-with-guix/)
    over time.
  - The new [“archival” checker of `guix
    lint`](https://guix.gnu.org/manual/en/html_node/Invoking-guix-lint.html#index-Software-Heritage_002c-source-code-archive)
    can send a “save” request to [Software
    Heritage](https://softwareheritage.org) for the specified packages.
    This helps improve [long-term archival of all the software Guix
    packages refer
    to](https://hpc.guix.info/blog/2019/03/connecting-reproducible-deployment-to-a-long-term-source-code-archive/).
  - The [`guix
    pull`](https://guix.gnu.org/manual/en/html_node/Invoking-guix-pull.html)
    command now honors `/etc/guix/channels.scm`.  This allows cluster
    administrators to specify a default set of
    [channels](https://guix.gnu.org/manual/en/html_node/Channels.html),
    which can help new users get started.

# Container provisioning

[`guix
pack`](https://guix.gnu.org/manual/en/html_node/Invoking-guix-pack.html),
the declarative and reproducible container provisioning tool, has
received noteworthy improvements:

  - When creating Docker or Singularity images, `guix pack` now record
    the environment variables needed for the execution of the
    applications added to the container.
  - Additionally, `guix pack` has a new [`--entry-point` command-line
    option](https://guix.gnu.org/manual/en/html_node/Invoking-guix-pack.html#index-entry-point_002c-for-Docker-images)
    to specify the name of the executable to run upon `docker run` or
    `singularity run`.
  - Docker images produced by `guix pack` now include an empty `/tmp`
    directory.  Images also have a meaningful “repository name” now (the
    name shown when running `docker images`).
  - Images produced by `guix pack -f squashfs` (for Singularity) are now
    reproducible bit-for-bit.  This makes it possible for anyone to
    independently verify the authenticity of such an image, and is
    generally a [prerequisite for better security and quality
    assurance](https://reproducible-builds.org/docs/buy-in/).
  - A [bug](https://issues.guix.gnu.org/issue/40043) was fixed that
    prevented `guix pack -f squashfs` from running on CentOS 7.

# Packages

Here are highlights among the 3,514 packages added and 3,368 packages
upgraded since the previous release:

  - [Guix-Jupyter](https://hpc.guix.info/package/guix-jupyter), which
    provides [Guix integration for Jupyter
    notebooks](https://hpc.guix.info/blog/2019/10/towards-reproducible-jupyter-notebooks/),
    was added.
  - The [Guix Workflow Language](https://hpc.guix.info/package/gwl),
    which integrates workflows with reproducible software deployment,
    has been upgraded to 0.2.1.
  - The [Open Cascade Technology Library
    (OCCT)](https://hpc.guix.info/package/opencascade-occt) is now
    packaged.
  - [MPICH](https://hpc.guix.info/package/mpich) is now available.
  - [Open MPI](https://hpc.guix.info/package/openmpi) is now at 4.0.3.
    Its packaging and that of high-speed network drivers [has been
    greatly
    improved](https://hpc.guix.info/blog/2019/12/optimized-and-portable-open-mpi-packaging/)
    to achieve performance on a wide range of networking products.
  - [hwloc](https://hpc.guix.info/package/hwloc), the hardware locality
    library Open MPI depends on, is now at 2.2.0.
  - [FEniCS](https://hpc.guix.info/package/fenics) and related packages
    were updated to 2019.1.0.post0.
  - [Julia](https://hpc.guix.info/package/julia) has been upgraded to
    1.3.1.  In addition, a new [_build system_ for Julia
    packages](https://guix.gnu.org/manual/en/html_node/Build-Systems.html#index-julia_002dbuild_002dsystem)
    is now available, making it easier to
    [package](https://guix.gnu.org/manual/en/html_node/Defining-Packages.html)
    Julia software in Guix.
  - [MPI4PY](https://hpc.guix.info/package/python-mpi4py) is now at
    3.0.2, and [SLEPC4PY](https://hpc.guix.info/package/python-slepc4py)
    and [PETSC4PY](https://hpc.guix.info/package/python-petsc4py) are at
    3.11.0.
  - [MUMPS](https://hpc.guix.info/package/mumps) has been updated to
    5.2.1 and its shared libraries are now installed.
  - For statisticians, there’s now a total of 1,368 R packages, many of
    which comes from [Bioconductor](https://www.bioconductor.org/).

Do not miss the [release
notes](https://guix.gnu.org/blog/2020/gnu-guix-1.1.0-released/) for
other goodies!

Enjoy the new release!
