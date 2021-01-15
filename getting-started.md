title: Reproducible software deployment for high-performance computing.
frontpage: yes
---

[GNU Guix](https://guix.gnu.org/) is a *transactional*
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

[We believe](/about) this makes Guix a great foundation for
reproducible software deployment in high-performance computing (HPC).
Here’s how to get started.

# Installing Guix

You can install Guix on your laptop in 5 minutes: just
follow
[the binary install instructions](https://guix.gnu.org/manual/en/html_node/Binary-Installation.html).

You’re a cluster sysadmin and would like to have a cluster-wide install?
Read [this article](/blog/2017/11/installing-guix-on-a-cluster).

# Installing Packages

Say you’re searching for a sparse solver among the
[14,000+ packages](/browse) that come with Guix:

```
$ guix search sparse solver
name: mumps
version: 5.0.2
outputs: out
systems: x86_64-linux i686-linux armhf-linux aarch64-linux
+ mips64el-linux
dependencies: gfortran-5.4.0 metis-5.1.0 openblas-0.2.19
+ scotch-6.0.4
location: gnu/packages/maths.scm:1550:2
homepage: http://mumps.enseeiht.fr
license: CeCILL-C
synopsis: Multifrontal sparse direct solver
description: MUMPS (MUltifrontal Massively Parallel sparse
+ direct Solver) solves a sparse system of linear equations
+ A x = b using Guassian elimination.
relevance: 12

…
```

To install it along with the latest GNU compiler tool chain:

```
$ guix install mumps gcc-toolchain
The following packages will be installed:
   mumps         5.2.1
   gcc-toolchain 10.2.0

The following derivation will be built:
   /gnu/store/kipa9k61zkhw4s3frs92w683ps23hpjj-profile.drv
3.1 MB will be downloaded

…

hint: Consider setting the necessary environment variables by running:

     GUIX_PROFILE="$HOME/.guix-profile"
     . "$GUIX_PROFILE/etc/profile"

Alternately, see `guix package --search-paths -p "$HOME/.guix-profile"'.
```

# Spawning One-Off Environments

Sometimes all you want is to try out a program without installing it in
your profile.  That’s
where
[`guix environment`](https://guix.gnu.org/manual/en/html_node/Invoking-guix-environment.html) comes
in.  To create an environment containing Python 3.x, NumPy, and
scikit-learn, run:

```
$ python3
bash: python3: Command not found
$ guix environment --ad-hoc python@3 python-numpy python-scikit-learn
The following derivation will be built:
   /gnu/store/2g3mj1xdlq2rj8j0crl4sa68bqhmfsmd-profile.drv
building directory of Info manuals...
building database for manual pages...
[env]$ python3
Python 3.5.3 (default, Jan  1 1970, 00:00:01) 
[GCC 5.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import numpy
>>> import sklearn
>>>
```

# Customizing Packages

Occasionally you’ll want to customize the way packages are
built.
[From the command line](https://guix.gnu.org/manual/en/html_node/Package-Transformation-Options.html),
you can apply transformations, such as replacing one dependency
with another one in the dependency graph.  The example below replaces
`openmpi` with `openmpi-thread-multiple` in the dependency graph of
`mumps-openmpi`:

```
$ guix install mumps-openmpi \
     --with-input=openmpi=openmpi-thread-multiple
```

The expressivity of the command line is limited, but you can go further
by writing your own package definitions.

# Defining Packages

To add a package, you
can
[generate a template from a third-party repository using `guix import`](https://guix.gnu.org/manual/en/html_node/Invoking-guix-import.html),
or you
can
[write a package definition](https://guix.gnu.org/manual/en/html_node/Defining-Packages.html),
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

You can have your own package collection published as a
[channel](https://guix.gnu.org/manual/en/html_node/Channels.html).

# Sending Packages to Guix-less Machines

What if the target supercomputer lacks Guix?  You can still enjoy Guix’s
reproducibility and customizability by [sending your package binaries
there](/blog/2017/10/using-guix-without-being-root/), leveraging
[relocatable
binaries](https://guix.gnu.org/blog/2018/tarballs-the-ultimate-container-image-format/):

```
laptop$ scp `guix pack -RR hwloc -S /bin=bin` supercomputer:hwloc.tar.gz
…
supercomputer$ mkdir -p ~/.local
supercomputer$ (cd ~/.local; tar xf ~/hwloc.tar.gz)
supercomputer$ ~/.local/bin/lstopo
```

Other options include building [Singularity or Docker
images](https://guix.gnu.org/manual/en/html_node/Invoking-guix-pack.html).

# Learning More

Find the main commands in the [quick reference
card](https://guix.gnu.org/guix-refcard.pdf).  Learn more
in the reference manual:
[Deutsch](https://guix.gnu.org/manual/de/html_node) |
[English](https://guix.gnu.org/manual/en/html_node) |
[español](https://guix.gnu.org/manual/es/html_node) |
[français](https://guix.gnu.org/manual/fr/html_node).

# Joining

Read about on-going Guix-HPC developments [on our blog](/blog).

[Guix-HPC](/about)
and [GNU Guix](https://guix.gnu.org/) are collaborative
efforts.  You are welcome to [join](/about)!
