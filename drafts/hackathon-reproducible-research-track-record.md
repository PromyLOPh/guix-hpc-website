title: Reproducible Research Hackathon: Track record
author: Simon Tournier
date: 2020-07-10 12:00
tags: Reproducible Science
---

On the Friday, July 3rd, we had a great [Hackathon
day](https://hpc.guix.info/blog/2020/06/reproducible-research-hackathon/) on
Reproducible Research
[issues](https://en.wikipedia.org/wiki/Replication_crisis).  This day was a
collaborative effort to bring GNU Guix to concrete examples inspired by to
contributions the recent [Ten Years Reproducibility
Challenge](https://rescience.github.io/ten-years/) organized by
[ReScience](https://rescience.github.io).

We were ~15 people connected on the `#guix-hpc` channel of irc.freenode.net.
The day was interspersed by three video chats; the first to exchange about
interests, background and working plan, the second to report the work in
progress and the last to address the achievements and list future ideas.  Here
a recap.

## Channel [`guix-past`](https://gitlab.inria.fr/guix-hpc/guix-past)

The aim of _Guix-past_ is to bring software from the past to the present: it
gives you packages from “back then” that you can deploy here and now.

The Hackathon had been the occasion to add packages of historical interest:

 - [Perl 5.14](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/b21bfbf70a39457b5491c1fbaf0f30d442767e87)
 - [SimGrid
   3.3](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/9b43fd25c893c4c04e89f9cf3b65dd1030dbfc91)
 - [GTnetS 2009](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/743993ae60ceb607b5a1c8783dfc27718cfa2d1f)
 - [Boost
   1.58](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/0eb2aae7d7bf92ae10d657d44f559fc614a9337b),
   [1.55](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/a287e663f74b19f17f8224cc3ee8691ae0e20274),
   and
   [1.44](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/24331f71317f4f01dc285ffe4af419e7a0798217)
 - [GNU Scientific Library 1.16](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/253271a829b2d749a4d350ac92806187924b4342)

Some work around [Fortran
77](https://github.com/ReScience/submissions/issues/41), Octave 3.4.3 with
[glibc
2.31](https://hg.savannah.gnu.org/hgweb/octave/file/b0e70a71647b/liboctave/lo-mappers.cc#l48)
and [opflow (1998)](https://github.com/ReScience/submissions/issues/43) had be
done but are not ready enough to be committed.

Working on old packages, two concerns about discoverability raised.

 - The release date of packages matters to facilitate finding the version that
   was current when a paper was published.  It had been discussed where to
   specify it? Synopsis or description or comment in the code?  The policy
   ends up with the use of the extra field:

   ```scheme
   (properties `((release-date . "2015-04-17")))
   ```

    The next step is to add UI to view properties from the command line.

 - The [`guix
   time-machine`](https://guix.gnu.org/manual/en/guix.html#Invoking-guix-time_002dmachine)
   command allows to build and install previous package versions.  However, it
   is not possible to go back before the introduction of
   [inferiors](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/b21bfbf70a39457b5491c1fbaf0f30d442767e87).
   For example, old Boost versions had already been packaged in Guix but they
   are unreachable and they had be backported to the `guix-past` channel with
   bare Git commands such as:

   ```
   git -C /path/to/guix-checkout log | grep -B4 "boost: Update"
   ```

   And version history is already available on the [Guix Data
   Service](https://data.guix.gnu.org/repository/1/branch/master/package/boost)
   and one of the idea should be to extend such historical search.

## Old Python ecosystem

The 10 years Python ecosystem is of wide interest.  For instance,
[GeneNetwork](https://genenetwork.org/) is a group of 25 years of legacy
linked data sets and tools used to study complex networks of genes, molecules,
and higher order gene function and phenotypes and the project needs to
generate time machines of the [platform version
1](http://gn1.genenetwork.org/webqtl/main.py).  Numpy and Matplotlib are
[frequently](https://github.com/ReScience/ten-years/issues/1) used and
specific [bioinformatics
tools](http://git.genenetwork.org/guix-bioinformatics/guix-bioinformatics)
require it.

The Hackathon had been the occasion to add over 16 commits:

 - [Numpy
   1.5.2](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/92bed98f7b0a411af695365e2e9ee2fdca470cab),
   [1.1.1](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/1050a67af1e04d300490eceb47dbb1d3569726ef),
   [1.0.4](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/2df4784cdb772667dcfd15638d32873b14c30262)
   and
   [1.2.1](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/53b992ae097cfb32972fe4de00f0a85cedb14235)
 - [Matplotlib
   1.1.0](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/ec24146a409ea05d793bca3ee315b954cd63e739)
   and [this](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/b04954f7048656a09a7397aacffb2420ed14192a)
 - [Python 2.4](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/45e749acd98d0627e9d8640d3d9ce2ea0749d79b)
 - [Nose](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/e3eaf0b32c77d35cecfed63c5f816552f49d10bb),
   [dateutil
   2.1](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/c155c0e337db1bb3f328e250e36c2431200fa80e),
   [Six
   1.4.1](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/6e56a6a896b11c97252aac9c226a7e71e0c3f9c1),
   [Pytest
   2.4.2](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/cc38fa0220ff0453f2dc56af42d9618692abb9a1)
   and [Argparse](https://gitlab.inria.fr/guix-hpc/guix-past/-/commit/a7d444c10a3cdeecacc5a8e0a19041989ba5f355)

An interesting issue left to explore is why Python 2.4 compiled with current
`gcc-toolchain` has a bug that it definitely did not have back then.  It
should probably be related to the many intentional ambiguities in the `C`
language standard.  This raised again the missing ability to replace the
_implicit dependencies_ used by the
[build-system](https://guix.gnu.org/manual/en/guix.html#Build-Systems).  It is
the opportunity to think if it is best to add `package-with-explicit-`
procedures for each build-system, as they already exist for
Python [here](https://git.savannah.gnu.org/cgit/guix.git/tree/guix/build-system/python.scm#n73)
or
Ocaml [there](https://git.savannah.gnu.org/cgit/guix.git/tree/guix/build-system/ocaml.scm#n99)
for example, or if it is best to _parametrize_ the build-systems.

## Towards long-term and archivable reproducibility

The ambition of [Software Heritage](https://www.softwareheritage.org/) is to
collect, preserve, and share all software that is publicly available in source
code form.  And Guix is able to interact with this archive.

Firstly, Guix can submit request for archiving via `guix lint -c archival`.
Once the package is ready, if the
[origin](https://guix.gnu.org/manual/en/guix.html#origin-Reference) is
`git-fetch`, then linting allows to preserve the source code on Software
Heritage.  The Hackathon exposed that the support of other version control
systems Subversion and Mercurial are missing.

Moreover, the Hackathon highlighted the
[work](https://forge.softwareheritage.org/source/swh-loader-core/browse/master/swh/loader/package/nixguix/)
in [progress](https://forge.softwareheritage.org/T2485) about archiving the
tarballs and the question is [raised](https://forge.softwareheritage.org/T2430).

Secondly, in the long term, it is hard to predict if the upstream server will
be always running, for [an example](http://issues.guix.gnu.org/42162).  In
such case, Guix can fallback to Software Heritage and download from there if
the source code is archived.  The Hackathon had been the occasion to discover
a [regression](http://issues.guix.gnu.org/42286) and to [fix
it](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=722ad41c44a499d2250c79527ef7d069ca728de0).

---
Schedule a day and work together is a good occasion to start playing with long
standing topics and it is much easier with people around for answering
practical questions, that would take a longer time to resolve by going trough
the documentation.  Therefore, [stay tuned](https://hpc.guix.info/blog/) for
other rounds.
