title: DRAFT Scientific packages for GNU Guix
author: Lars-Dominik Braun
date: 2020-12-04 13:00:00
slug: guix-science
tags: packages
---

With increased usage of GNU Guix at scientific institutions there are also
growing needs for packaging software used in research and teaching. The best
place for that has been and still is Guix’ main repository because there the
software is accessible and maintainable by the entire Guix community.

However some packages cannot be included there, because of the repository’s
inclusion policy. RStudio for instance is notorious for vendoring components
and difficult to build from source entirely. As another example JupyterLab
bundles precompiled JavaScript, which cannot be unbundled without also
packaging npm.

This has resulted in different institutes creating their own Guix channels and
useful packages being scattered in different git repositories. For instance [UMCU’s
channel](https://github.com/UMCUGenetics/guix-additions) provides a package
definition for RStudio that was copied from [BIMSB’s Guix
channel](https://github.com/BIMSBbioinfo/guix-bimsb). At Leibniz Institute for
Psychology (ZPID) we also used to maintain our own version of RStudio in [our
Guix channel](https://github.com/leibniz-psychology/guix-zpid).

Since there is a demand for these kind of packages we at ZPID decided to
move our package definitions of RStudio, JupyterLab and JASP into a
vendor-neutral channel called
[guix-science](https://github.com/guix-science/guix-science). The channel has a
more relaxed inclusion policy regarding usage of prebuilt components than Guix
itself and thus can include software that is difficult to build from source. It
uses Guix’ authorization mechanism to build a trusted source of package
definitions. Currently the three owners of the GitHub organization Ricardo
Wurmus (BIMSB), Roel Janssen (UMCU) and me are also authorized committers.
Binary substitutes, which we build for our own infrastructure, are publicly
available for everyone at https://substitutes.guix.psychnotebook.org/. See the
[README
file](https://github.com/guix-science/guix-science/blob/master/README.rst) on
how to use them.

We welcome contributions of new package definitions, as well as improvements to
existing ones and hope to foster collaboration amongst scientific institutes
who deploy software using GNU Guix.

