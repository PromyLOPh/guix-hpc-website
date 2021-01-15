title: Reproducibility vs. root privileges
slug: reproducibility-and-root-privileges
author: Ludovic Courtès
date: 2017-09-22 14:00:00
tags: reproducibility root-privileges namespaces singularity shifter easybuild spack
---

Guix is a good fit for multi-user environments such as clusters:
it
[allows non-root users to install packages at will without interfering with each other](https://guix.gnu.org/manual/html_node/Features.html).
However, a common complaint is that installing Guix requires administrator
privileges.  More precisely, `guix-daemon`, the system-wide daemon that
spawns package builds and downloads on behalf of
users,
[must be running as `root`](https://guix.gnu.org/manual/html_node/Build-Environment-Setup.html).
This is not much of a problem on one's laptop but it surely makes it
harder to adopt Guix on an HPC cluster.

So why does Guix have this requirement when other tools don’t?  In this
article we look at the various options available today to achieve build
isolation—a prerequisite for reproducible builds—on GNU/Linux, and how HPC
software deployment tools address the problem.

# Creating isolated environments

GNU Guix prides itself on being able to create isolated build
environments, which in turn helps make sure that package builds are
reproducible
([the same inputs yield the same output](https://reproducible-builds.org/docs/definition/))
regardless of what software is installed on the machine or what machine
performs the build.  It does that in the traditional Unix way, which
we'll describe below.

## `chroot` and `setuid`

Unix-like operating systems have traditionally provided a couple of
tools to isolate processes:
[`chroot`](http://man7.org/linux/man-pages/man2/chroot.2.html), which
allows a process to “see” a different root file system, and
[`setuid`](http://man7.org/linux/man-pages/man2/setuid.2.html), which
allows a process to run on behalf of a different user.

`guix-daemon` uses these two mechanisms when it builds something: it
`chroot`s into an environment where only the declared dependencies of a
build process are accessible, and it `setuid`s to a specific “build
user” that does not run any process other than this one build process.
For this reason, the manual instructs
[to create a pool of build users upfront](https://guix.gnu.org/manual/html_node/Build-Environment-Setup.html).

These two mechanisms are all it takes to achieve process isolation.  Of
course processes still run under the same operating system kernel as
before, unlike what a virtual machine would provide, but the rest is
unshared.  Today this is the only portable way to achieve process
isolation on a POSIX system.

In addition, `guix-daemon` runs processes in
[separate PID, networking, and mount “namespaces”](https://git.savannah.gnu.org/cgit/guix.git/tree/nix/libstore/build.cc#n1978).
“Namespaces” are
[a feature of the kernel Linux](http://man7.org/linux/man-pages/man7/namespaces.7.html)
to improve process isolation.  For example, a process running under a
separate PID namespace has a different _view_ of the existing set of
process IDs; it cannot reference a process running in a separate
PID namespace.

## User namespaces

The problem of `chroot`, `setuid`, and namespaces is that they are
available only to `root`.  A few years ago, the kernel Linux gained
support for
so-called
[“user namespaces”](http://man7.org/linux/man-pages/man7/user_namespaces.7.html),
which hold the promise of providing unprivileged users with a way to
isolate processes.  Unfortunately, user namespaces are still disabled by
most
distributions
[for fear of security issues](http://rhelblog.redhat.com/2015/07/07/whats-next-for-containers-user-namespaces/)—and
I should say rightfully so if we look, for example,
at
[this May 2017 `PF_PACKET` vulnerability in the kernel](https://googleprojectzero.blogspot.com/2017/05/exploiting-linux-kernel-via-packet.html),
which was exploitable by unprivileged users in a user namespace.

Hopefully this will be fixed in the not-too-distant future, but for the
time being, this is not a feature we can expect to find on HPC clusters,
on which we want to install Guix.

## When everything else fails

When none of the above is available, the remaining option to achieve
process isolation is [PRoot](https://github.com/proot-me/PRoot/).  PRoot
is a program that runs your application and uses the `ptrace`
system call to intercept all its system calls and, if permitted,
“translates” them into an equivalent system call in the “host”
environment.

For example, PRoot can do [file system virtualization akin to `chroot`
and bind mounts](https://github.com/proot-me/PRoot/blob/master/doc/proot/manual.txt).
To do that, it needs to intercept `open` calls, and translate file names
in the isolated environments to file names _outside_ the environment—or
raise an error when trying to access files that are not mapped into the
isolated environment.

The downside of this is performance: intercepting and translating system
calls is costly.  On the other hand, a mostly-computational application
such as a long-running numerical simulation will be largely unaffected
by this overhead.

In a future post we will see how to take advantage of PRoot in
conjunction with `guix pack`.

# What do others do?

In the context of HPC software deployment, people have been looking at
ways to achieve reproducibility, and also to avoid requiring root
privileges.  As we’ve seen above, it’s usually a tradeoff that must be
made.

## EasyBuild and Spack

[EasyBuild](https://easybuilders.github.io/easybuild/)
and [Spack](https://spack.io/), two package managers designed for HPC
clusters, have the advantage of not requiring root privileges at all.
Thus, provided Python is installed on the cluster you want to use, you
can readily install them and use them to build the packages they
provide.

This advantage comes at the cost of reproducibility.  Build processes
are not isolated from the rest of the system, so they can pick and
choose software from the host distribution.  The distributions of Spack
and EasyBuild are actually not self-contained: they _assume_ that some
specific packages are available on the host system, such as a C compiler
or the GNU Binutils.

This leads to very concrete reproducibility issues, where
things
[might build on one machine](https://github.com/hpcugent/easybuild-easyblocks/issues/293) [and fail to build on another](https://github.com/LLNL/spack/issues/2055),
simply because the core software packages differ.

## Singularity

[Singularity](http://singularity.lbl.gov) is a tool to build and create
Docker-style application bundles (sometimes confusingly referred to as
“containers”).  To run those application bundles, it needs at the very
least file system virtualization—it needs to “map” file names within the
image at the same place in the execution environment.

Singularity’s web
site
[explains](http://singularity.lbl.gov/about#no-root-owned-daemon-processes) that
no root-owned daemon processes are required on the HPC cluster where it
is used.  However, it
also [notes](http://singularity.lbl.gov/docs-security) that it needs
either a setuid-root helper program to create isolated environments on
behalf of users, or support for user namespaces.  In practice, that
means that only cluster admins can install it today.

## Shifter

[Shifter](http://www.nersc.gov/research-and-development/user-defined-images/) relies
on the Docker daemon to execute application bundles, which needs to be
installed as root.

## runc

[runc](https://github.com/opencontainers/runc) prides itself on having
“the ability to run containers without root privileges”, which they call
_rootless containers_.  There is no magic here: its implementation
simply
[requires support for user namespaces](https://github.com/opencontainers/runc/commit/d2f49696b09a60f5ab60f7db8259c52a2a2cdbed).

# Summary

Guix requires a root-owned daemon to perform isolated builds, which are
the foundation for reproducible software environments.  This makes it
less readily available to HPC cluster users: you have to convince your
system administrators to install it before you can happily use it to
manage your software (here’s a trick: tell them that’ll give you more
flexibility _and_ also relieve them from the tedious manual management
of environment modules :-)).

However, the kernel Linux does not yet provide a mechanism for
non-root users to build isolated environments.  In the future, when user
namespaces are widely available, the problem will be solved.  But for
now, if you value reproducibility, let’s talk to cluster sysadmins and
invite them to install `guix-daemon`.

But wait, we also have a solution for you in the meantime.  More on that
in a future post.  :-)
