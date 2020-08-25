title: Reproducible research articles, from source code to PDF
author: Ludovic Courtès
date: 2020-06-16 14:00
tags: Research, Reproducibility
---

Early this year, [ReScience](https://rescience.github.io), which is
concerned with publishing replications (successful or not) of
previously-published articles, organized the [Ten Years Reproducibility
Challenge](https://rescience.github.io/ten-years/).  The idea is simple:
pick a paper of yours that is at least ten years old, and try to
replicate its results.  The first difficulty is usually to get the
source code of the software used to produce the results and to get that
code to build and run.  This challenge helped highlight
[again](https://en.wikipedia.org/wiki/Replication_crisis) ways in which
research practices can and must be improved.  We took it as an
opportunity to devise new practices and tools to ensure reproducibility
and provenance tracking for articles, end-to-end: from source code to
PDF.

> Update: Nature [reports on the
> challenge](https://www.nature.com/articles/d41586-020-02462-7) (August
> 2020).

Over fifty people [took up on the
challenge](https://github.com/ReScience/ten-years/issues/1).  My
personal challenge was a paper from 2006; I [successfully reproduced its
results](https://doi.org/10.5281/zenodo.3886739) and, more importantly,
came up with a methodology and tool set to do so:

> This article reports on the effort to reproduce the results shown in
> [_Storage Tradeoffs in a Collaborative Backup Service for Mobile
> Devices_](https://hal.inria.fr/hal-00187069/en), an article published
> in 2006, more than thirteen years ago.  The article presented the
> design of the storage layer of such a backup service.  It included an
> evaluation of the efficiency and performance of several storage
> pipelines, which is the experiment we replicate here.
>
> Additionally, this article describes a way to capture the complete
> dependency graph of this article and the software and data it refers
> to, making it fully reproducible, end to end.  Using
> [GNU Guix](https://hal.inria.fr/hal-01161771/en), we bridge together
> code that deploys the software evaluated in the paper, scripts that
> run the evaluation and produce plots, and scripts that produce the
> final PDF file from LaTeX source and plots.  The end result—and the
> major contribution of this article—is approximately 400 lines of code
> that allow Guix to rebuild the whole article _and the experiment it
> depends on_ with a well-specified, reproducible software environment.

[The article](https://doi.org/10.5281/zenodo.3886739) describes the
methodology and use of Guix in some detail, explains its pratical
benefits, and compares to widespread methods and tools—Jupyter notebooks
and container images, to name the most popular ones.  The code to build
the whole software stack used in the article, to run its experiments,
produce charts, and produce the final PDF from its LaTeX code is in
`guix.scm` and `article/guix.scm` in [the source
repository](https://gitlab.inria.fr/lcourtes-phd/edcc-2006-redone).

The article concludes on our vision:

> We hope our work could serve as the basis of a template for
> reproducible papers in the spirit of [Maneage](http://maneage.org/).
> We are aware that, in its current form, our reproducible pipeline
> requires a relatively high level of Guix expertise—although, to be
> fair, it should be compared with the wide variety of programming
> languages and tools conventionally used for similar purposes.  We
> think that, with more experience, common build processes and idioms
> could be factorized as libraries and high-level programming
> constructs, making it more approachable.
>
> […] We look forward to a future where reproducible scientific
> pipelines become commonplace.

As Konrad Hinsen [put
it](https://github.com/ReScience/submissions/issues/32#issuecomment-634149030)
during the review process, this is “advanced reproducibility wizardry”
and can be seen as a “proof of concept for future technology”.  Let’s
build that technology!
