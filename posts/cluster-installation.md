title: Installing Guix on a cluster
author: Ludovic Courtès
date: 2017-11-23 15:30
tags: cluster installation sysadmin
---

Previously we
[discussed](https://hpc.guix.info/blog/2017/10/using-guix-without-being-root)
ways to use Guix-produced packages on a cluster where Guix is not
installed.  In this post we look at how a cluster sysadmin can install
Guix for system-wide use, and discuss the various tradeoffs.

# Setting up a “master” node

The recommended approach is to set up one *master node* running
`guix-daemon` and exporting `/gnu/store` over NFS to compute nodes.

Remember that
[`guix-daemon`](https://guix.gnu.org/manual/html_node/Invoking-guix_002ddaemon.html)
is responsible for spawning build processes and downloads on behalf of
clients, and more generally accessing
[`/gnu/store`](https://guix.gnu.org/manual/html_node/The-Store.html),
which contains all the package binaries built by all the users.
“Client” here refers to all the Guix commands that users see, such as
`guix package`.  On a cluster, these commands may be running on the
compute nodes and we’ll want them to talk to the master node’s
`guix-daemon` instance.

To begin with, the master node can be installed following the [binary
installation
instructions](https://guix.gnu.org/manual/html_node/Binary-Installation.html),
which should be straightforward.

Since we want `guix-daemon` to be reachable not just from the master
node but also from the compute nodes, we’ll use the new TCP transport
[recently added](https://bugs.gnu.org/27426) as part of the Guix-HPC
effort and part of the forthcoming 0.14.0 release:

```
root@master# vi /etc/systemd/system/guix-daemon.service
```

and from there we’ll add `--listen` arguments to the `ExecStart` line:

```
ExecStart=/var/guix/profiles/per-user/root/guix-profile/bin/guix-daemon --build-users-group=guixbuild --listen=/var/guix/daemon-socket/socket --listen=0.0.0.0
```

The `--listen=0.0.0.0` bit means that `guix-daemon` will process *all*
incoming TCP connections on port 44146.  This is usually fine in a
cluster setup where the master node is reachable exclusively from the
cluster’s LAN—you don’t want that to be exposed to the Internet!

The next step is to define our NFS exports in
[`/etc/exports`](https://linux.die.net/man/5/exports) by adding
something along these lines:

```
/gnu/store  *(ro)
/var/guix   *(rw, async)
```

The `/gnu/store` directory can be exported read-only since only
`guix-daemon` on the master node will ever modify it.  `/var/guix`
contains *user profiles* as managed by `guix package`; thus, to allow
users to install packages with `guix package`, this must be read-write.

Users can create as many profiles as they like in addition to the
default profile, `~/.guix-profile`.  For instance, `guix package -p
~/dev/python-dev -i python` installs Python in a profile reachable from
the `~/dev/python-dev` symlink.  To make sure that this profile is
protected from garbage collection—i.e., that Python will not be removed
from `/gnu/store` while this profile exists—, home directories should be
mounted on the master node as well so that `guix-daemon` knows about
these non-standard profiles and avoids collecting software they refer
to.

It may be a good idea to periodically remove unused bits from
`/gnu/store` by running [`guix
gc`](https://guix.gnu.org/manual/html_node/Invoking-guix-gc.html).
This can be done by adding a crontab entry on the master node:

```
root@master# crontab -e
```

… with something like this:

```
# Every day at 5AM, run the garbage collector to make sure
# at least 10 GB are free on /gnu/store.
0 5 * * 1  /var/guix/profiles/per-user/root/guix-profile/bin/guix gc -F10G
```

We’re done with the master node!  Let’s look at compute nodes now.

# Setup on compute nodes

First of all, we need to tell `guix` to talk to the daemon running on
our master node, by adding these lines to `/etc/profile`:

```
GUIX_DAEMON_SOCKET="guix://master.guix.example.org"
export GUIX_DAEMON_SOCKET
```

To avoid warnings and make sure `guix` uses the right locale, we need to
tell it to use locale data provided by Guix:

```
GUIX_LOCPATH=/var/guix/profiles/per-user/root/guix-profile/lib/locale
export GUIX_LOCPATH

# Here we must use a valid locale name.  Try "ls $GUIX_LOCPATH/*"
# to see what names can be used.
LC_ALL=fr_FR.utf8
export LC_ALL
```

For convenience, `guix package` [automatically
generates](https://guix.gnu.org/manual/html_node/Invoking-guix-package.html)
`~/.guix-profile/etc/profile`, which defines all the environment
variables necessary to use the packages—`PATH`, `C_INCLUDE_PATH`,
`PYTHONPATH`, etc.  Thus it’s a good idea to source it from
`/etc/profile`:

```
GUIX_PROFILE="$HOME/.guix-profile"
if [ -f "$GUIX_PROFILE/etc/profile" ]; then
  . "$GUIX_PROFILE/etc/profile"
fi
```

Last but not least, Guix provides command-line completion notably for
Bash and zsh.  In `/etc/bashrc`, consider adding this line:

```
. /var/guix/profiles/per-user/root/guix-profile/etc/bash_completion.d/guix
```

Voilà!

You can check that everything’s in place by logging in on a compute node
and running:

```
guix package -i hello
```

The daemon on the master node should download pre-built binaries on your
behalf and unpack them in `/gnu/store`, and `guix package` should create
`~/.guix-profile` containing the `~/.guix-profile/bin/hello` command.

# Network access

Guix requires network access to download source code and pre-built
binaries.  The good news is that only the master node needs that since
compute nodes simply delegate to it.

It is customary for cluster nodes to have access at best to a _white
list_ of hosts.  Our master node needs at least `mirror.hydra.gnu.org`
in this white list since this is where it gets pre-built binaries from,
for all the packages that are in Guix proper.

Incidentally, `mirror.hydra.gnu.org` also serves as a _content-addressed
mirror_ of the source code of those packages.  Consequently, it is
sufficient to have _only_ `mirror.hydra.gnu.org` in that white list.

Software packages maintained in a separate repository like [that of
Inria](https://gitlab.inria.fr/guix-hpc/guix-hpc) or [that of
MDC/BIMSB](https://github.com/BIMSBbioinfo/guix-bimsb) of course isn’t
mirror on `mirror.hydra.gnu.org`.  For these packages, the situation is
different.  One solution is to [run your own
mirror](https://guix.gnu.org/manual/html_node/Invoking-guix-publish.html)
on the local network.  Another solution, as a last resort, is to let
users download source on their workstation and add it to the cluster’s
`/gnu/store`, like this:

```
workstation$ GUIX_DAEMON_SOCKET=ssh://compute-node.example.org \
  guix download http://starpu.gforge.inria.fr/files/starpu-1.2.3/starpu-1.2.3.tar.gz
```

The above command downloads `starpu-1.2.3.tar.gz` _and_ sends it to the
cluster’s `guix-daemon` instance over SSH.

Air-gapped clusters require more work.  At the moment, our suggestion
would be to download all the necessary source code on a workstation
running Guix.  For instance, using the [`--sources` option of `guix
build`](https://guix.gnu.org/manual/html_node/Additional-Build-Options.html),
the example below downloads all the source code the `openmpi` package
depends on:

```
$ guix build --sources=transitive openmpi

…

/gnu/store/xc17sm60fb8nxadc4qy0c7rqph499z8s-openmpi-1.10.7.tar.bz2
/gnu/store/s67jx92lpipy2nfj5cz818xv430n4b7w-gcc-5.4.0.tar.xz
/gnu/store/npw9qh8a46lrxiwh9xwk0wpi3jlzmjnh-gmp-6.0.0a.tar.xz
/gnu/store/hcz0f4wkdbsvsdky3c0vdvcawhdkyldb-mpfr-3.1.5.tar.xz
/gnu/store/y9akh452n3p4w2v631nj0injx7y0d68x-mpc-1.0.3.tar.gz
/gnu/store/6g5c35q8avfnzs3v14dzl54cmrvddjm2-glibc-2.25.tar.xz
/gnu/store/p9k48dk3dvvk7gads7fk30xc2pxsd66z-hwloc-1.11.8.tar.bz2
/gnu/store/cry9lqidwfrfmgl0x389cs3syr15p13q-gcc-5.4.0.tar.xz
/gnu/store/7ak0v3rzpqm2c5q1mp3v7cj0rxz0qakf-libfabric-1.4.1.tar.bz2
/gnu/store/vh8syjrsilnbfcf582qhmvpg1v3rampf-rdma-core-14.tar.gz
…
```

(In case you’re wondering, that’s more than 320 MiB of _compressed_
source code.)

We can then make a big
[archive](https://guix.gnu.org/manual/html_node/Invoking-guix-archive.html)
containing all of this:

```
$ guix archive --export \
    `guix build --sources=transitive openmpi` \
    > openmpi-source-code.nar
```

… and we can eventually transfer that archive to the cluster on
removable storage and unpack it there:

```
$ guix archive --import < openmpi-source-code.nar
```

This process has to be repeated every time new source code needs to be
brought to the cluster.

As we write this, the research institutes involved in Guix-HPC do not
have air-gapped clusters though.  If you have experience with such
setups, we would like to hear feedback and suggestions.

# Disk usage

A common concern of sysadmins’ is whether this is all going to eat a lot
of disk space.  If anything, if something is going to exhaust disk
space, it’s going to be scientific data sets rather than compiled
software.  With more than three years of experience running Guix on the
cluster of the Max Delbrück Center, Ricardo Wurmus notes that disk usage
does grow, but that overall Guix’s store is not a major contributor.
Nevertheless, it’s worth taking a look at how Guix contributes to disk
usage.

First, having several versions or variants of a given package in
`/gnu/store` does not necessarily cost much, because `guix-daemon`
implements deduplication of identical files, and package variants are
likely to have a number of common files.

As mentioned above, we recommend having a cron job to run `guix gc`
periodically, which removes *unused* software from `/gnu/store`.
However, there’s always a possibility that users will keep lots of
software in their profiles, or lots of old generations of their
profiles, which is “live” and cannot be deleted from the viewpoint of
`guix gc`.

The solution to this is for users to regularly remove old generations of
their profile.  For instance, the following command removes generations
that are more than two-month old:

```
$ guix package --delete-generations=2m
```

Likewise, it’s a good idea to invite users to regularly upgrade their
profile, which can reduce the number of variants of a given piece of
software stored in `/gnu/store`:

```
$ guix pull
$ guix package -u
```

As a last resort, it is always possible for sysadmins to do some of this
on behalf of their users.  Nevertheless, one of the strengths of Guix is
the freedom and control users get on their software environment, so we
strongly recommend leaving users in control.

# Security considerations

On an HPC cluster, Guix is typically used to manage scientific software.
Security-critical software such as the operating system kernel and
system services such as `sshd` and the batch scheduler remain under
control of sysadmins.

The Guix project has a good track record [delivering security updates in
a timely
fashion](https://guix.gnu.org/manual/html_node/Security-Updates.html).
To get security updates, users have to run `guix pull && guix package
-u`.

Because Guix uniquely identifies software variants, it is easy to see if
a vulnerable piece of software is in use.  For instance, to check
whether the glibc 2.25 variant without the mitigation patch against
“[Stack
Clash](https://www.qualys.com/2017/06/19/stack-clash/stack-clash.txt)”,
one can check whether user profiles refer to it at all:

```
$ guix gc --referrers /gnu/store/…-glibc-2.25
```

This will report whether profiles exist that refer to this specific
glibc variant.

# Summary

Guix can readily be installed cluster-wide on a cluster.  The task
primarily involves installing Guix on a master node and exporting
`/gnu/store` and `/var/guix` over NFS to compute node, and possibly
augmenting the firewall’s white list to allow the master node to
retrieve software binaries and source code.

This setup gives cluster users a great level of control over their
computing environment.  Users can reproduce the exact same environment
on their laptop and on other clusters using Guix, which we think is key
to the reproducibility of scientific experiments.

# Acknowledgments

Thanks to Ricardo Wurmus at the Max Delbrück Center and to Julien
Lelaurain at Inria for their feedback on an earlier draft of this post.
