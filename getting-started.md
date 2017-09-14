[GNU Guix](https://www.gnu.org/software/guix/) is a *transactional*
package manager, with support for *per-user* package installations.
Users can install their own packages without interfering with each
other, yet without unnecessarily increasing disk usage or rebuilding
every package.  Users can in fact create as many software environments
as they like—think of it
as [VirtualEnv](https://virtualenv.pypa.io/en/stable/) but not limited
to Python, or [`modules`](http://modules.sourceforge.net/) but not
limited to your sysadmin-provided modules.

The software environments created with Guix are _fully reproducible_: a
package built from a specific Guix commit on your laptop will be exactly
the same as the one built on the HPC cluster you deploy it too, usually
[bit-for-bit](https://reproducible-builds.org/docs/definition/).

[We believe](/about.html) this makes Guix a great foundation for
reproducible software deployment in high-performance computing (HPC).
Here’s how to get started.

# Installing Guix

Guix can be installed in 5 minutes: just
follow
[the binary install instructions](https://www.gnu.org/software/guix/manual/html_node/Binary-Installation.html).

# Installing Packages

The
[`guix package` command](https://www.gnu.org/software/guix/manual/html_node/Invoking-guix-package.html) is
the entry point.  Say you’re searching for a sparse solver among the
[6,000+ packages](https://www.gnu.org/software/guix/packages/) that come
with Guix:

```
$ guix package -s sparse -s solver
name: mumps
version: 5.0.2
outputs: out
systems: x86_64-linux i686-linux armhf-linux aarch64-linux mips64el-linux
dependencies: gfortran-5.4.0 metis-5.1.0 openblas-0.2.19 scotch-6.0.4
location: gnu/packages/maths.scm:1550:2
homepage: http://mumps.enseeiht.fr
license: CeCILL-C
synopsis: Multifrontal sparse direct solver
description: MUMPS (MUltifrontal Massively Parallel sparse direct Solver) solves a
+ sparse system of linear equations A x = b using Guassian elimination.
relevance: 12

name: superlu
version: 5.2.1
outputs: out
systems: x86_64-linux i686-linux armhf-linux aarch64-linux mips64el-linux
dependencies: gfortran-5.4.0 openblas-0.2.19 tcsh-6.20.00
location: gnu/packages/maths.scm:1756:2
homepage: http://crd-legacy.lbl.gov/~xiaoye/SuperLU/
license: Modified BSD, GPL 2+, FSF-free
synopsis: Supernodal direct solver for sparse linear systems
description: SuperLU is a general purpose library for the direct solution of large,
+ sparse, nonsymmetric systems of linear equations on high performance machines.  The
+ library is written in C and is callable from either C or Fortran.  The library
+ routines perform an LU decomposition with partial pivoting and triangular system
+ solves through forward and back substitution.  The library also provides
+ threshold-based ILU factorization preconditioners.
relevance: 9

…
```

To install it along with the latest GNU compiler tool chain:

```
$ guix package -i mumps gcc-toolchain
The following packages will be installed:
   mumps	5.0.2	/gnu/store/gg55pn4nk3fl7fvxqqsgqr2w6fds7wa6-mumps-5.0.2
   gcc-toolchain	7.2.0	/gnu/store/zs62l7rwvk5180cz3bykjprk2fymsnbs-gcc-toolchain-7.2.0

substitute: updating list of substitutes from 'https://mirror.hydra.gnu.org'... 100.0%
The following derivations will be built:
   /gnu/store/kipa9k61zkhw4s3frs92w683ps23hpjj-profile.drv
   /gnu/store/73lzwjvr6wx4gb3l9a7vlx6759kcgp7h-fonts-dir.drv
   /gnu/store/3zkyjqg8wsxvypj6ivjpfp9h4lpf9cyg-ca-certificate-bundle.drv
   /gnu/store/37jya2s4kwbkldwfc98x5jvsdynmzzz8-info-dir.drv
   /gnu/store/bihbksjnbhnaxkwbnh03drffmx85vcsm-manual-database.drv
3.1 MB will be downloaded:
   /gnu/store/gg55pn4nk3fl7fvxqqsgqr2w6fds7wa6-mumps-5.0.2

…

2 packages in profile
The following environment variable definitions may be needed:
   export PATH="$HOME/.guix-profile/bin:$HOME/.guix-profile/sbin${PATH:+:}$PATH"
   export C_INCLUDE_PATH="$HOME/.guix-profile/include${C_INCLUDE_PATH:+:}$C_INCLUDE_PATH"
   export CPLUS_INCLUDE_PATH="$HOME/.guix-profile/include${CPLUS_INCLUDE_PATH:+:}$CPLUS_INCLUDE_PATH"
   export LIBRARY_PATH="$HOME/.guix-profile/lib${LIBRARY_PATH:+:}$LIBRARY_PATH"
```

# Spawning One-Off Environments

Sometimes all you want is to try out a program without installing it in
your profile.  That’s
where
[`guix environment`](https://www.gnu.org/software/guix/manual/html_node/Invoking-guix-environment.html) comes
in.  To create an environment containing Python 3.x and NumPy, run:

```
$ guix environment --ad-hoc python@3 python-numpy
The following derivations will be built:
   /gnu/store/2g3mj1xdlq2rj8j0crl4sa68bqhmfsmd-profile.drv
   /gnu/store/wd0ma3xjq25w2qcnn3x0dgjyrck3dnk0-info-dir.drv
   /gnu/store/n97xqbig6rfliqrw0qbkb1zbnh8v0dis-fonts-dir.drv
   /gnu/store/igdhg9hm5n4npvf41zvznm06c226kx4a-ca-certificate-bundle.drv
   /gnu/store/my4m438264jyq5awk39j20xhdf6symha-manual-database.drv
Creating manual page database for 1 packages... done in 0.021 s
[env]$ python3
Python 3.5.3 (default, Jan  1 1970, 00:00:01) 
[GCC 5.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import numpy
>>> 
```

# Customizing Packages

Occasionally you’ll want to customize the way packages are
built.
[From the command line](https://www.gnu.org/software/guix/manual/html_node/Package-Transformation-Options.html),
you can make apply transformations, such as replacing one dependency
with another one in the dependency graph.  The example below replaces
`openmpi` with `openmpi-thread-multiple` in the dependency graph of
`mumps-openmpi`:

```
$ guix package -i mumps-openmpi \
     --with-input=openmpi=openmpi-thread-multiple
```

The expressivity of the command line is limited, but you can go further
by writing your own package definitions.

# Defining Packages

To add a package, you
can
[generate a template from a third-party repository using `guix import`](https://www.gnu.org/software/guix/manual/html_node/Invoking-guix-import.html),
or you
can
[write a package definition](https://www.gnu.org/software/guix/manual/html_node/Defining-Packages.html),
which looks like this:

```scheme
(define-public scalapack
  (package
    (name "scalapack")
    (version "2.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://www.netlib.org/scalapack/scalapack-"
                           version ".tgz"))
       (sha256
        (base32
         "0p1r61ss1fq0bs8ynnx7xq4wwsdvs32ljvwjnx6yxr8gd6pawx0c"))))
    (build-system cmake-build-system)
    (inputs
     `(("mpi" ,openmpi)
       ("fortran" ,gfortran)
       ("lapack" ,lapack)))             ;for testing only
    (arguments
     `(#:configure-flags `("-DBUILD_SHARED_LIBS:BOOL=YES")))
    (home-page "http://www.netlib.org/scalapack/")
    (synopsis "Library for scalable numerical linear algebra")
    (description
     "ScaLAPACK is a Fortran 90 library of high-performance linear algebra
routines on parallel distributed memory machines.  ScaLAPACK solves dense and
banded linear systems, least squares problems, eigenvalue problems, and
singular value problems.")
    (license (license:bsd-style "file://LICENSE"
                                "See LICENSE in the distribution."))))
```

You can have your personal package collection:
just
[add it to `$GUIX_PACKAGE_PATH`](https://www.gnu.org/software/guix/manual/html_node/Package-Modules.html).

# Joining

[Guix-HPC](/about.html)
and [GNU Guix](https://www.gnu.org/software/guix/) are collaborative
efforts.  You are welcome to [join](/about.html)!
