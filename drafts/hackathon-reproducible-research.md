title: Reproducible Research Hackathon
author: Simon Tournier
date: 2020-06-29 14:00
tags: Reproducible Science
---

Several submissions to the recent [Ten Years Reproducibility
Challenge](https://rescience.github.io/ten-years/) organized by
[ReScience](https://rescience.github.io), which is concerned with publishing
replications of previously-published articles, have took advantages of [GNU
Guix](https://guix.gnu.org), for example this effort: [from source code to
PDF](https://hpc.guix.info/blog/2020/06/reproducible-research-articles-from-source-code-to-pdf/).

 This challenge helped highlight
[again](https://en.wikipedia.org/wiki/Replication_crisis) ways in which
research practices can and must be improved.  For instance, one review
explains that [_archival of the source code is not
enough_](https://github.com/ReScience/submissions/issues/20#issuecomment-636458152)
and another points evolutions and breaking changes of [well-known scientific
library](https://github.com/ReScience/submissions/issues/14#issuecomment-583528044).

We propose to collectively tackle some of the issues by dedicating the
**Friday, July 3rd** to work on:

 - identify the blocking points,
 - document how to do, maybe it could lead to a Cookbook recipe,
 - feed the [Guix-Past](https://gitlab.inria.fr/guix-hpc/guix-past) channel
    by other old packages,
 - provide `guix.scm` for some of the [Ten-Year
    papers](https://github.com/ReScience/ten-years/issues/1).

Feel free to join us.

 - [`guix-devel@gnu.org`](mailto:guix-devel@gnu.org) 
 -  the `#guix` channel on irc.freenode.net
    [http://guix.gnu.org/contact/irc/](http://guix.gnu.org/contact/irc/)

And we plan to live discuss over a video chat for sharing progress, sucesss or
failure, maybe screen or more.  Link will be published on `#guix` and
`guix-devel@gnu.org`.


---

Here is a non-exhaustive list of ideas:

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
