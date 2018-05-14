title: Paper on reproducible bioinformatics pipelines with Guix
date: 2018-05-09 12:00
author: Ricardo Wurmus
tags: High-performance computing, Research, Reproducibility, Bioinformatics
---
I’m happy to announce that the bioinformatics group at the [Max
Delbrück Center](https://www.mdc-berlin.de/) that I’m working with has
released a preprint of a paper on reproducibility with the title
[Reproducible genomics analysis pipelines with GNU
Guix](https://doi.org/10.1101/298653).

We built a collection of [bioinformatics pipelines called "PiGx"
("Pipelines in Genomix")](http://bioinformatics.mdc-berlin.de/pigx)
and packaged them as first-class packages with GNU Guix.  Then we
looked at the degree to which the software achieves
bit-reproducibility, analysed sources of non-determinism (e.g. time
stamps), discussed experimental reproducibility at runtime
(e.g. random number generators, the interface provided by the kernel
and the GNU C library, etc) and commented on the practice of using
“containers” (or application bundles) instead.

[Reproducible builds](https://reproducible-builds.org) is a crucial
foundation for computational experiments.  We hope that PiGx and the
reproducibility analysis we presented in the paper can serve as a
useful case study demonstrating the importance of a principled
approach to computational reproducibility and the effectiveness of
Guix in the pursuit of reproducible software management.

> _Originally published [on the Guix
> blog](https://www.gnu.org/software/guix/blog/2018/paper-on-reproducible-bioinformatics-pipelines-with-guix/)._
