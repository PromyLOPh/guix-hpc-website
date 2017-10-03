title: Using Guix Without Being root
author: Ludovic Courtès
date: 2017-10-02 15:00:00
tags: pack bundle PRoot container
---

In [the previous
post](/blog/2017/09/reproducibility-and-root-privileges), we saw that
Guix’s build daemon needs to run as `root`, and for a good reason:
that’s currently the only way to create isolated build environments for
packages on GNU/Linux.  This requirement means that you cannot use Guix
on a cluster where the sysadmins have not already installed it.  In this
article, we discuss how to take advantage of Guix on clusters that lack
a proper Guix installation.

# Setting the stage

So you get access to one of these powerful supercomputers, which will
allow you to run (and/or debug :-)) your number crunching application in
the parallel setting of your dreams.  Now, before you can get there, you
first have to _deploy_ your application, and that’s where things often
start looking muddy: the machine runs an ancient GNU/Linux with a bunch
of sysadmin-provided “environment modules.”

Most likely you’ll end up building your application and its
dependencies by hand, just to notice later that it doesn’t quite behave
the same way as on your lab’s cluster, and yet again differently from
what happens on your laptop.  Wouldn’t it be great if you could use the
exact same software on all these machines?

# Creating bundles with `guix pack`

Earlier this year, [we announced `guix
pack`](https://www.gnu.org/software/guix/news/creating-bundles-with-guix-pack.html),
a command that allows you to create a _binary bundle_ of a set of
packages and all their dependencies.  For instance, we can create a
tarball containing the [hwloc hardware topology
toolkit](https://www.open-mpi.org/projects/hwloc/) and its dependencies
by running:

```
$ guix pack hwloc -S /bin=bin
…
/gnu/store/…-tarball-pack.tar.gz
```

The `-S` switch here instructs `guix pack` to create a `/bin` symlink
inside the tarball that points to hwloc’s `bin` directory (more on
that in [this blog
post](https://www.gnu.org/software/guix/news/creating-bundles-with-guix-pack.html)
and in [the
manual](https://www.gnu.org/software/guix/manual/html_node/Invoking-guix-pack.html)).
The tarball contains two directories at its root: this `/bin` symlink,
and `/gnu/store`, which contains the actual binaries.

We can send this tarball to the supercomputer:

```
laptop$ scp `guix pack hwloc -S /bin=bin` supercomputer:hwloc.tar.gz
```

… and then unpack it on the supercomputer:

```
supercomputer$ mkdir -p ~/.local
supercomputer$ cd ~/.local
supercomputer$ tar xf ~/hwloc.tar.gz
```

The problem that we have now is that we cannot run these binaries, first
because `~/.local/bin` is a symlink to `/gnu/store`, which does not
exist on that machine, and second because binaries in general are not
relocatable.

So we need to _map_ `$HOME/.local/gnu/store` to `/gnu/store` in the
execution environment of hwloc.  We’ve [seen
before](/blog/2017/09/reproducibility-and-root-privileges) that this
normally requires root privileges, so let’s see how we can work around
that.

# User namespaces again

Once again, [user
namespaces](http://man7.org/linux/man-pages/man7/user_namespaces.7.html)
can save us—when they’re available.  With the
[`unshare`](http://man7.org/linux/man-pages/man1/unshare.1.html) and
[`chroot`](https://www.gnu.org/software/coreutils/chroot) commands, we
can create that environment:

```
$ unshare -mrf chroot ~/.local /bin/lstopo --version
lstopo 1.11.8
```

This command creates a new process in a separate mount and user
namespace, in which it runs `chroot` to change the root to
`$HOME/.local` and finally invoke hwloc’s `lstopo`.  In this
environment, `/bin/lstopo` actually corresponds to
`$HOME/.local/bin/lstopo`.

Unfortunately, few HPC installations offer this option today, so we need
another solution.

# PRoot

In the absence of user namespaces, we can resort to
[PRoot](/package/proot).  PRoot supports OS resource virtualization in a
way conceptually similar to namespaces.  It does that by tracing
processes with
[`ptrace`](http://man7.org/linux/man-pages/man2/ptrace.2.html), the
system call that debuggers rely on, which does _not_ require `root`
privileges.

Guix comes with a [`proot-static`](/package/proot-static) package, which
is a statically-linked version of PRoot.  Because it’s statically
linked, we can build it on our laptop send it to the remote machine and
directly use it there:

```
laptop$ scp `guix build proot-static`/bin/proot supercomputer:
```

On the supercomputer, we can now run `lstopo` under PRoot, and tell
`proot` to use `~/.local` as the root file system:

```
supercomputer$ ./proot -r ~/.local /bin/lstopo
Machine + Package L#0 + L3 L#0 (15MB) + L2 L#0 (256KB) + L1d L#0 (32KB) + L1i L#0 (32KB) + Core L#0 + PU L#0 (P#0)
```

Wait, `lstopo` is telling us that there’s a single CPU with a single
core on that machine, what’s wrong?  Well, we also need to map `/proc`
in the execution environment of `lstopo`, since this is where it gets
most of the information from:

```
supercomputer$ ./proot -r ~/.local -b /proc /bin/lstopo
Machine (126GB)
  Package L#0
    L3 L#0 (15MB)
      L2 L#0 (256KB) + L1d L#0 (32KB) + L1i L#0 (32KB) + Core L#0 + PU L#0 (P#0)
      L2 L#1 (256KB) + L1d L#1 (32KB) + L1i L#1 (32KB) + Core L#1 + PU L#1 (P#2)
      L2 L#2 (256KB) + L1d L#2 (32KB) + L1i L#2 (32KB) + Core L#2 + PU L#2 (P#4)
      L2 L#3 (256KB) + L1d L#3 (32KB) + L1i L#3 (32KB) + Core L#3 + PU L#3 (P#6)
      L2 L#4 (256KB) + L1d L#4 (32KB) + L1i L#4 (32KB) + Core L#4 + PU L#4 (P#8)
      L2 L#5 (256KB) + L1d L#5 (32KB) + L1i L#5 (32KB) + Core L#5 + PU L#5 (P#10)
    L3 L#1 (15MB)
      L2 L#6 (256KB) + L1d L#6 (32KB) + L1i L#6 (32KB) + Core L#6 + PU L#6 (P#12)
      L2 L#7 (256KB) + L1d L#7 (32KB) + L1i L#7 (32KB) + Core L#7 + PU L#7 (P#14)
      L2 L#8 (256KB) + L1d L#8 (32KB) + L1i L#8 (32KB) + Core L#8 + PU L#8 (P#16)
      L2 L#9 (256KB) + L1d L#9 (32KB) + L1i L#9 (32KB) + Core L#9 + PU L#9 (P#18)
      L2 L#10 (256KB) + L1d L#10 (32KB) + L1i L#10 (32KB) + Core L#10 + PU L#10 (P#20)
      L2 L#11 (256KB) + L1d L#11 (32KB) + L1i L#11 (32KB) + Core L#11 + PU L#11 (P#22)
  Package L#1
    …
```

So now we have a simple way to run an application from a binary bundle
created with `guix pack`, and to selectively expose OS resources such as
`/proc` or `/dev` nodes.

PRoot does not require `root` privileges, but it comes with a
performance hit: the traced process _stops at every system call_ while
`proot` itself interprets and “translates” the system call.  Quite
heavy-handed.  However, for a mostly computational process, it should
not be much of a problem: the I/O phases of the program’s execution will
be slower, but the core of the program’s execution should be largely
unaffected.  An MPI may still be penalized though, but we do not have
benchmarking results for that yet.

# Singularity, Docker, Shifter

Another solution to run your Guix pack is _via_ Singularity, Shifter, or
Docker if one of them is installed on your supercomputer.
[All](https://docs.docker.com/engine/reference/commandline/load/)
[three](http://singularity.lbl.gov/docs-import)
[tools](http://www.nersc.gov/users/software/using-shifter-and-docker/using-shifter-at-nersc/)
are able to load Docker images, and `guix pack` can create such images:

```
$ guix pack -f docker -S /bin=bin hwloc
…
/gnu/store/…-docker-pack.tar.gz
```

You would then send that image to the supercomputer, import it with
`singularity import` or `docker load`.  Then we can run:

```
$ singularity exec docker-pack.tar.gz /bin/lstopo
…
```

Or:

```
$ IMAGE=`docker load -i docker-pack.tar.gz | cut -d' ' -f3`
$ docker run $IMAGE /bin/lstopo
…
```

In this sense, Shifter, Docker, and Singularity provide a nice
foundation to run our application bundles.


# Why bother?

At this point, you may be wondering: if we’re doing to use Docker or
Singularity or Shifter to run our bundle, why bother with `guix pack` in
the first place?  These tools also provide commands to provision
container images, after all.

The answer is simple: with Guix, the bundle _is a reproducible byproduct
for which you have the source_.  That is, if you pick a commit of Guix,
`guix pack hwloc` will always give the same result,
[bit-for-bit](https://reproducible-builds.org/docs/definition/).  And
it’s not limited to bundles: `guix package -i hwloc` allows you to
install the very same hwloc.

With Docker & co., the bundle is at the center of the stage.  You surely
have a
[`Dockerfile`](https://docs.docker.com/get-started/part2/#define-a-container-with-a-dockerfile)
or a [“bootstrap
recipe”](http://singularity.lbl.gov/quickstart#bootstrap-recipes) which
allows you to rebuild the image.  While they provide a convenient way to
provision an image, `Dockerfile`s and Singularity recipes have several
shortcomings, from a reproducible science viewpoint:

  1. `Dockerfile`s and recipes do _not_ describe a reproducible image
     build process: they typically resort to external tools such as
     `apt-get` or `pip`, whose results depend on the state of the
     Debian or PyPI repository at the time they are run.
  2. They tell only a small part of the story: the core of a Docker
     image is the [“base
     layer”](https://docs.docker.com/engine/docker-overview/#docker-objects),
     which is an opaque operating system image, and the `apt-get` and
     `pip` commands in the `Dockerfile` or recipe do not really tell us
     how those binaries we’re adding were produced.
  3. They are the wrong abstraction level: when creating an
     _application_ bundle, it makes more sense to think in terms of the
     application and the software it depends on, than to think in terms
     of commands to run to modify the state of the image.

To put it differently, `Dockerfile`s and Singularity recipes _are not
source_, and the binary they lead to are pretty much inert.

In contrast, Guix describes the _complete_ dependency graph of the
application—the [`guix
graph`](https://www.gnu.org/software/guix/manual/html_node/Invoking-guix-graph.html)
command allows us to visualize that.  For each package in the graph, we
know not only what packages it depends on, but also which patches,
configure flags, compiler options, and so on are used to build it.

Since Guix knows how to build everything, customizing the package graph
and recreating a new bundle is easy.  For instance, using the
[command-line package transformation
options](https://www.gnu.org/software/guix/manual/html_node/Package-Transformation-Options.html),
we can produce a pack of hwloc built from a different source tarball,
but otherwise with the same dependency graph and build options:

```
$ guix pack hwloc -S /bin=bin --with-source=./hwloc-2.0.0rc1.tar.gz
```

Likewise, we could create a bundle of the [MUMPS sparse
solver](/package/mumps) linked against [PT-Scotch](/package/pt-scotch)
instead of [Scotch](/package/scotch):

```
$ guix pack mumps -S /bin=bin --with-input=scotch=pt-scotch
```

If the command-line options are not enough, we can always go further
[using the
API](https://www.gnu.org/software/guix/manual/html_node/Defining-Packages.html).

# Wrap-up

For systems lacking a Guix installation, `guix pack` provides a
convenient way to provision container images that can be executed either
with Docker, Singularity, or Shifter, or simply with PRoot—without
requiring root privileges.  `guix pack` distinguishes itself from other
approaches to image provisioning by retaining the nice properties of
Guix: it makes bundles _reproducible from source_, provides a high level
of abstraction, and supports customization and experimentation.
