title: Connecting reproducible deployment to a long-term source code archive
author: Ludovic Courtès
tags: Reproducible builds, Reproducibility, Research, Scheme API
date: 2019-03-29 15:50:00
---

GNU Guix can be used as a “package manager” to install and upgrade
software packages as is familiar to GNU/Linux users, or as an
environment manager, but it can also provision containers or virtual
machines, and manage the operating system running on your machine.

One foundation that sets it apart from other tools in these areas is
_reproducibility_.  From a high-level view, Guix allows users to
_declare_ complete software environments and instantiate them.  They can
share those environments with others, who can replicate them or adapt
them to their needs.  This aspect is key to reproducible computational
experiments: scientists need to reproduce software environments before
they can reproduce experimental results, and this is one of the things
we are focusing on in the context of the
[Guix-HPC](https://hpc.guix.info) effort.  At a lower
level, the project, along with others in the [Reproducible
Builds](https://reproducible-builds.org) community, is working to ensure
that software build outputs are [reproducible,
bit for bit](https://reproducible-builds.org/docs/definition/).

Work on reproducibility at all levels has been making great progress.
Guix, for instance, allows you to [travel back in
time](https://www.gnu.org/software/guix/blog/2018/multi-dimensional-transactions-and-rollbacks-oh-my/).
That Guix can travel back in time _and_ build software reproducibly is a
great step forward.  But there’s still an important piece that’s missing
to make this viable: a stable source code archive.  This is where
[Software Heritage](https://www.softwareheritage.org) (SWH for short)
comes in.

# When source code vanishes

Guix contains thousands of package definitions.  Each [package
definition](https://www.gnu.org/software/guix/manual/en/html_node/Defining-Packages.html)
specifies the package’s source code URL and hash, the package’s
dependencies, and its build procedure.  Most of the time, the package’s
source code is an archive (a “tarball”) fetched from a web site, but
more and more frequently the source code is a specific revision checked
out directly from a version control system.

The obvious question, then, is: what happens if the source code URL
becomes unreachable?  The whole reproducibility endeavor collapses when
source code disappears.  And source code _does_ disappear, or, even
worse, it can be modified in place.  At GNU we’re doing a good job of
having stable hosting that keeps releases around “forever”, unchanged
(modulo rare exceptions).  But a lot of free software out there is
hosted on personal web pages with a short lifetime and on commercial
hosting services that come and go.

By default Guix would look up source code by hash in the caches of our
build farms.  This comes for free: the [“substitute”
mechanism](https://www.gnu.org/software/guix/manual/en/html_node/Substitutes.html)
extends to all “build artifacts”, including downloads.  However, with
limited capacity, our build farms do not keep all the source code of all
the packages for a long time.  Thus, one could very well find oneself
unable to rebuild a package months or years later, simply because its
source code disappeared or moved to a different location.

# Connecting to the archive

It quickly became clear that reproducible builds had “reproducible
source code downloads”, so to speak, as a prerequisite.  The Software
Heritage archive is the missing piece that would finally allow us to
reproduce software environments years later in spite of the volatility
of code hosting sites.  Software Heritage’s mission is to archive
essentially “all” the source code ever published, including version
control history.  Its archive already periodically ingests release
tarballs from the GNU servers, repositories from GitHub, packages from
PyPI, and much more.

![Software Heritage logo](https://www.gnu.org/software/guix/static/blog/img/software-heritage-logo-title.svg)

We quickly settled on a scheme where Guix would fall back to the
Software Heritage archive whenever it fails to download source code from
its original location.  That way, package definitions don’t need to be
modified: they still refer to the original source code URL, but the
downloading machinery transparently goes to Software Heritage when
needed.

There are two types of source code downloads in Guix: tarball downloads,
and version control checkouts.  In the former case, resorting to
Software Heritage is easy: Guix knows the SHA256 hash of the tarball so
it can look it up by hash using [the `/content` endpoint of the
archive’s
interface](https://archive.softwareheritage.org/api/1/content/raw/).

Fetching version control checkouts is more involved.  In this case, the
downloader would first resolve the commit identifier to obtain a
[Software Heritage
revision](https://archive.softwareheritage.org/api/1/revision/).  The
actual code for that revision is then fetched through the
[_vault_](https://docs.softwareheritage.org/devel/swh-vault/api.html).

The vault conveniently allows users to fetch the tarball corresponding
to a revision.  However, not all revisions are readily available as
tarballs (understandably), so the vault has an interface that allows you
to request the “_cooking_” of a specific revision.  Cooking is
asynchronous and can take some time.  Currently, if a revision hasn’t
been cooked yet, the Guix download machinery will request it and wait
until it is available.  The process can take some time but will
eventually succeed.

Success!  At this point, we have essentially bridged the gap between the
stable archive that Software Heritage provides and the reproducible
software deployment pipeline of Guix.  This code [was
integrated](https://issues.guix.info/issue/33432) in November 2018,
making it the first free software distribution backed by a stable
archive.

# The challenges ahead

This milestone was encouraging: we had seemingly achieved our goal, but
we also knew of several shortcomings.  First, even though the software
we package is still primarily distributed as tarballs, Software Heritage
keeps relatively few of these tarballs.  Software Heritage does ingest
tarballs, notably those found on [the GNU
servers](https://ftp.gnu.org/gnu/), but the primary focus is on
preserving complete version control repositories rather than release
tarballs.

It is not yet clear to us what to do with plain old tarballs.  On one
hand, they are here and cannot be ignored.  Furthermore, some provide
artifacts that are not in version control, such as `configure` scripts,
and often enough they are accompanied by a cryptographic signature from
the developers that allows recipients to _authenticate_ the code—an
important piece of information that’s often missing from version control
history.  On the other hand, version control tags are increasingly
becoming the mechanism of choice to distribute software releases.  It
may be that tags will become the primary mechanism for software release
distribution soon enough.

Version control tags turn out not to be ideal either, because they’re
mutable and per-repository.  Conversely, Git commit identifiers are
unambiguous and repository-independent because they’re essentially
content-addressed, but our package definitions often refer to tags, not
commits, because that makes it clearer that we’re providing an actual
release and not an arbitrary revision (this is another illustration of
[Zooko’s triangle](https://en.wikipedia.org/wiki/Zooko's_triangle)).

This leads to another limitation that stems from the mismatch between
the way Guix and Software Heritage compute hashes over version control
checkouts: both compute a hash over a serialized representation of the
directory, but they serialize the directory in a different way (SWH
serializes directories as Git trees, while Guix uses “normalized
archives” or Nars, the format the build daemon manipulates, which is
inherited from Nix.)  That prevents Guix from looking up revisions by
content hash.  The solution will probably involve changing Guix to
support the same method as Software Heritage, and/or adding Guix’s method
to Software Heritage.

Having to wait for “cooking” completion can also be problematic.  The
Software Heritage team is investigating the possibility to
[automatically cook all version control
tags](https://forge.softwareheritage.org/T1350).  That way, relevant
revisions would almost always be readily available through the vault.

Similarly, we have no guarantee that software provided by Guix is
available in the archive.  Our plan is to [extend Software
Heritage](https://forge.softwareheritage.org/T1352) such that it would
periodically archive the source code of software packaged by Guix.

# Going further

In the process of adding support for Software Heritage, Guix [gained
Guile bindings to the Software Heritage HTTP
interface](https://issues.guix.info/issue/33432).  Here’s a couple of
things we can do:

```scheme
(use-modules (guix swh))

;; Check whether SWH has ever crawled our repository.
(define o (lookup-origin "https://git.savannah.gnu.org/git/guix.git"))
⇒ #<<origin> id: 86312956 …>

;; It did! When was its last visit?
(define last-visit
  (first (origin-visits o)))

(date->string (visit-date last-visit))
⇒ "Fri Mar 29 10:07:45Z 2019"

;; Does it have our “v0.15.0” Git tag?
(lookup-origin-revision "https://git.savannah.gnu.org/git/guix.git" "v0.15.0")
⇒ #<<revision> id: "359fdda40f754bbf1b5dc261e7427b75463b59be" …>
```

Guix itself is a Guile library so when we combine the two, there are
interesting things we can do:

```scheme
(use-modules (guix) (guix swh)
			 (gnu packages base)
			 (gnu packages golang))

;; This is our GNU Coreutils package.
coreutils
⇒ #<package coreutils@8.30 gnu/packages/base.scm:342 1c67b40>

;; Does SWH have its tarball?
(lookup-content (origin-sha256 (package-source coreutils))
				"sha256")
⇒ #<<content> checksums: (("sha1" …)) data-url: …>

;; Our package for HashiCorp’s Configuration Language (HCL) is
;; built from a Git commit.
(define commit
  (git-reference-commit
	(origin-uri (package-source go-github-com-hashicorp-hcl))))

;; Is this particular commit available in the archive?
(lookup-revision commit)
⇒ #<<revision> id: "23c074d0eceb2b8a5bfdbb271ab780cde70f05a8" …>
```

We’re currently using a subset of this interface, but there’s certainly
more we could do.  For example, we can compute archive coverage of the
Guix packages; we can also request the archival of each package’s source
code _via_ the [“save code”
interface](https://archive.softwareheritage.org/api/1/origin/save/)—though
all this is subject to [rate
limiting](https://archive.softwareheritage.org/api/#rate-limiting).

# Wrap-up

Software Heritage support in Guix creates a bridge from the stable
source code archive to reproducible software deployment with complete
provenance tracking.  For the first time it gives us a software package
distribution that can be rebuilt months or years later.  This is
particularly beneficial in the context of reproducible science: finally
we can describe reproducible software environments, a prerequisite for
reproducible computational experiments.

Going further, we can provide a complete software supply tool chain with
provenance tracking that links revisions in the archive to
bit-reproducible build artifacts produced by Guix.  Oh and Guix itself
[is
archived](https://archive.softwareheritage.org/api/1/origin/git/url/https://git.savannah.gnu.org/git/guix.git/),
so we have this meta-level where we could link Guix revisions to the
revisions of packages it provides…  There are still technical challenges
to overcome, but that vision is shaping up.

> _Originally published [on the Guix
> blog](https://www.gnu.org/software/guix/blog/2019/connecting-reproducible-deployment-to-a-long-term-source-code-archive/)._
