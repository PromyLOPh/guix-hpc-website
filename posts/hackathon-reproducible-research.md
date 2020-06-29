title: Reproducible Research Hackathon
author: Simon Tournier
date: 2020-06-30 12:00
tags: Reproducible Science
---

Several submissions to the recent [Ten Years Reproducibility
Challenge](https://rescience.github.io/ten-years/) organized by
[ReScience](https://rescience.github.io) took advantage of GNU Guix, [as
discussed
earlier](https://hpc.guix.info/blog/2020/06/reproducible-research-articles-from-source-code-to-pdf/).

 This challenge helped highlight
[again](https://en.wikipedia.org/wiki/Replication_crisis) ways in which
research practices can and must be improved.  For instance, one review
explains that [_archival of the source code is not
enough_](https://github.com/ReScience/submissions/issues/20#issuecomment-636458152)
and another points evolutions and breaking changes of [well-known scientific
libraries](https://github.com/ReScience/submissions/issues/14#issuecomment-583528044).

We propose to collectively tackle some of the issues on
**Friday, July 3rd**:

 - identify stumbling blocks in using Guix to write end-to-end pipelines,
 - document how to achieve this,
 - feed the [Guix-Past](https://gitlab.inria.fr/guix-hpc/guix-past) channel
    by other old packages,
 - provide `guix.scm` for some of the [Ten-Year
    papers](https://github.com/ReScience/ten-years/issues/1).

Feel free to contact us at [`guix-hpc@gnu.org`](mailto:guix-hpc@gnu.org) if
you would like to hack with us.

We will meet at **9:30 CEST** on the `#guix-hpc` channel of irc.freenode.net.
You can use this [web client](http://guix.gnu.org/contact/irc/) (tweaking the
channel) to reach us.

---

Here is a non-exhaustive list of ideas, inspired by contributions to the
[Ten-Year Reproducibility
Challenge](https://github.com/rescience/submissions/issues?q=is%3Aissue++label%3A%22Ten+Years+Challenge%22+)
run by the journal [ReScience C](https://rescience.github.io/):

 1. Package old software that is of sufficiently wide interest.
    - Fortran `g77`, see this [example](https://github.com/ReScience/submissions/issues/41).
    - SciPy ecosystem from 2007 (Python, NumPy and matplotlib),
      see this [example](https://github.com/ReScience/submissions/issues/14).
 2. Package highly specialized research software - where packaging means
    writing a `guix.scm`. The long-term goal is to learn how to make this kind
    of packaging easier by providing templates reusable by scientists.
    Typical real-world examples sorted by difficulty order:
    - [Standard Fortran
      code](https://github.com/ReScience/submissions/issues/42) with only the
      popular `BLAS` and `LAPACK` libraries as dependencies.
    - [Medium-sized Fortran
      code](https://github.com/ReScience/submissions/issues/36) using a
      `Makefile`.
    - [Mixed C-Fortran
      code](https://github.com/ReScience/submissions/issues/41) using
      Autotools; the difficulty arises from the requirement of the abandoned
      `g77` compiler.
    - [Medium-sized Fortran
      code](https://github.com/ReScience/submissions/issues/20) adding its own
      wrapper aroung the compiler.
 3. Fully automated reproductions of results (typically figures).  This
    [submission](https://github.com/ReScience/submissions/issues/39) is a
    fully reproducible replicate based on Debian and its
    [`debuerreotype`](https://packages.debian.org/buster/debuerreotype)
    system. How do it compare with Guix?

--- 

There's a lot we can do and we'd love to [hear your
ideas](https://hpc.guix.info/about)!

Drop us an email at [`guix-hpc@gnu.org`](mailto:guix-hpc@gnu.org).
