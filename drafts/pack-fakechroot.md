title: Faster relocatable packs with Fakechroot
author: Ludovic Courtès
date: 2020-05-18 14:30
tags: reproducibility, user namespaces, pack
---

The [`guix
pack`](https://guix.gnu.org/manual/en/html_node/Invoking-guix-pack.html)
command creates “application bundles” that can be used to deploy
software on machines that do not run Guix, such as HPC clusters.  Since
[its inception in
2017](https://guix.gnu.org/blog/2017/creating-bundles-with-guix-pack/),
it has seen a number of improvements, such as the ability to create
Docker and Singularity container images.  Some clusters lack these
tools, though, and the addition of [relocatable
packs](https://guix.gnu.org/blog/2018/tarballs-the-ultimate-container-image-format/)
was a way to address that.  This post looks at a new _execution engine_
for relocatable packs that [has just
landed](https://issues.guix.gnu.org/41189) with the goal of improving
performance.

Before we get into that, let’s recap how relocatable packs work.

# Relocatable packs

Essentially, a relocatable pack is a [plain old
tarball](https://guix.gnu.org/blog/2018/tarballs-the-ultimate-container-image-format/)
that contains the applications of your choosing along with all their
dependencies, such that you can run them on any GNU/Linux machine.  To
create a pack containing Python and NumPy, run:

```
guix pack -RR python python-numpy -S /bin=bin
```

The `-RR` flag asks for the creation of a “reliably relocatable” pack
(more on that below), while the `-S` flag asks for the creation of a
`/bin` symlink in the tarball.

The result of that command is a tarball that you can send on another
machine, unpack, and the run Python directly from there without any
special privileges:

```
tar xf pack.tar.gz
./bin/python
```

That’s it!  All you need on the target machine is `tar`, and the rest
just works.

# Relocation with PRoot

`guix pack -R` (with a single `-R`) creates relocatable packs that
require [unprivileged user
namespaces](http://man7.org/linux/man-pages/man7/user_namespaces.7.html).
However, some systems have them disabled, and older systems do not
support them at all—the `./bin/python` command above wouldn’t work on
them.

The `-RR` option we saw above adds a universal fallback option: on a
system where unprivileged user namespaces are not available, the
`./bin/python` command above automatically falls back to using
[PRoot](https://hpc.guix.info/package/proot) instead.  PRoot achieves
file system virtualization by intercepting the process’ system calls
with [`ptrace`](https://linux.die.net/man/2/ptrace).

The advantage is that it always works—it doesn’t rely on any special
kernel feature, `ptrace` has “always been there” so to speak.  The
drawback is that it incurs significant overhead at _every_ system call.
This is acceptable for an interactive program, or, say, for a
single-threaded number-crunching application.  But the performance hit
is prohibitive, for example, for an MPI application or a multi-threaded
application—input/output and synchronization happen _via_ system calls.

# Enter Fakechroot

To address that, we added a third “execution engine” to relocatable
packs relying on
[ELF](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)
trickery.  Users of relocatable packs can now choose at run time an
execution engine by setting the `GUIX_EXECUTION_ENGINE` environment
variable.  If you choose the `performance` engine, the application will
choose either user namespaces or, if they are not supported, fallback to
the new `fakechroot` engine:

```
export GUIX_EXECUTION_ENGINE=performance
./bin/python
```

`guix pack -RR` wraps the application executables, in this case
`python`; those wrappers are [small statically-linked programs that
implement the execution
engines](https://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/aux-files/run-in-namespace.c).
The new `fakechroot` engine works like that:

  1. The `PT_INTERP` segment of the wrapped executable contains the file
     name of the dynamic linker, `ld.so`, under `/gnu/store`.  Since
     `/gnu/store` doesn’t exist on the host machine, the dynamic linker
     is invoked directly, with its file name computed relative to the
     wrapper’s file name.

  2. The loader is told to preload the
     [Fakechroot](https://hpc.guix.info/package/fakechroot) shared
     library, which interposes on the file system functions of the C
     library (`open`, `stat`, etc.) and “translates” `/gnu/store`
     absolute file names to their actual location.

  3. The `RUNPATH` of Guix executables and shared libraries lists the
     `/gnu/store` directories that contain the libraries they depend on.
     The `open` calls that `ld.so` itself makes are not interposable, so
     Fakechroot doesn’t help here.  However, the little-known [_audit_
     interface of the GNU dynamic
     linker](https://linux.die.net/man/7/rtld-audit) comes in handy: its
     `la_objsearch` hook allows you to alter the way `ld.so` looks for
     shared libraries.  Thus, [a few lines of
     C](https://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/aux-files/pack-audit.c)
     are all it takes to get `ld.so` to translate `/gnu/store` file
     names.  Neat!

The `fakechroot` engine incurs very little overhead, and only on file
system function calls, making it a viable option for HPC workloads.  The
default engine remains user namespaces with a fallback to PRoot, so be
sure to set `GUIX_EXECUTION_ENGINE=performance`!  See [the
manual](https://guix.gnu.org/manual/devel/en/html_node/Invoking-guix-pack.html)
for more info.

# A call to HPC system administrators

`guix pack -RR` allows you to deploy software stacks on a Guix-less
cluster that lacks both support for unprivileged user namespaces and a
container facility such as Singularity, without loss of performance.
It’s good to take a step back though, and look at the bigger picture.

All these shenanigans would be unnecessary if unprivileged user
namespaces were universally available.  In fact, when we released `guix
pack -R` [two years
ago](https://guix.gnu.org/blog/2018/tarballs-the-ultimate-container-image-format/),
we thought (hoped?) that widespread availability of unprivileged user
namespaces was imminent.  After all, the feature had already been
available in the Linux kernel since version 3.8, released in 2013.

Unfortunately, today, major academic HPC clusters still run a derivative
of Red Hat Enterprise Linux (RHEL) or CentOS 7, released in 2015 with
Linux 3.10, where the decision was made [to disable user
namespaces](https://www.redhat.com/en/blog/whats-next-containers-user-namespaces).
RHEL 8 and derivatives are
[documented](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/building_running_and_managing_containers/index#set_up_for_rootless_containers)
as having an easy way to set up user namespaces.

We encourage HPC system administrators to consider enabling unprivileged
user namespaces.  They are allow unprivileged users to deploy pre-built
software, being through a relocatable Guix pack or _via_ [container
run-time support tools like
runC](https://github.com/opencontainers/runc/commit/d2f49696b09a60f5ab60f7db8259c52a2a2cdbed),
without overhead.  More generally, they [enable reproducible software
environments](https://hpc.guix.info/blog/2017/09/reproducibility-and-root-privileges/),
a prerequisite for reproducible scientific experiments!

# Acknowledgments

Many thanks to Carlos O’Donell, steward for the GNU C Library, for
reviewing initial revisions of the `fakechroot` execution engine and for
suggesting the use of the `ld.so` audit interface.
