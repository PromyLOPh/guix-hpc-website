title: Guix-HPC Activity Report, 2020
author: Simon Tournier
date: 2021-02-01 14:00
slug: guix-hpc-activity-report-2020
---
_This document is also available as
[PDF](https://hpc.guix.info/static/doc/activity-report-2020.pdf)
([printable
booklet](https://hpc.guix.info/static/doc/activity-report-2020-booklet.pdf))._

Guix-HPC is a collaborative effort to bring reproducible software
deployment to scientific workflows and high-performance computing (HPC).
Guix-HPC builds upon the [GNU Guix](https://guix.gnu.org) software
deployment tool and aims to make it a better tool for HPC practitioners
and scientists concerned with reproducible research.

Guix-HPC was launched in September 2017 as a joint software development
project involving three research institutes:
[Inria](https://www.inria.fr/en/), the [Max Delbrück Center for
Molecular Medicine (MDC)](https://www.mdc-berlin.de/), and the [Utrecht
Bioinformatics Center (UBC)](https://ubc.uu.nl/).  GNU Guix for HPC and
reproducible science has received contributions from additional
individuals and organizations, including [CNRS](https://www.cnrs.fr/en),
[Cray, Inc.](https://www.cray.com), the [University of Tennessee Health
Science Center](https://uthsc.edu/) (UTHSC), and [Tourbillion
Technology](http://tourbillion-technology.com/).

This report highlights key achievements of Guix-HPC between [our
previous
report](https://hpc.guix.info/blog/2019/02/guix-hpc-activity-report-2019/)
a year ago and today, February 2021.  This year was marked by two releases:
[version 1.1.0 in April 2020](https://hpc.guix.info/blog/2020/04/hpc-reproducible-research-in-guix-1.1.0/)
and [version 1.2.0 in November](https://hpc.guix.info/blog/2020/11/hpc-reproducible-research-in-guix-1.2.0/).

# Outline

Guix-HPC aims to tackle the following high-level objectives:

  - *Reproducible scientific workflows.*  Improve the GNU Guix tool set
    to better support reproducible scientific workflows and to simplify
    sharing and publication of software environments.
  - *Cluster usage.* Streamlining Guix deployment on HPC clusters, and
    providing interoperability with clusters not running Guix.
  - *Outreach & user support.*  Reaching out to the HPC and scientific
    research communities and organizing training sessions.

The following sections detail work that has been carried out in each of
these areas.

# Reproducible Scientific Workflows

![Lab book.](https://hpc.guix.info/static/images/blog/lab-book.svg)

Supporting reproducible research in general remains a major goal for
Guix-HPC.  The ability to _reproduce_ and _inspect_ computational
experiments—today’s lab notebooks—is key to establishing a rigorous
scientific method.  We believe that a prerequisite for this is the
ability to reproduce and inspect the software environments of those
experiments.  We have made further progress to ensure Guix addresses
this use case.

## The Guix Workflow Language

TODO: extensions

## Ensuring Source Code Availability

TODO: sources.json, SWH and Nix

## Packaging

TODO: guix-science
TODO: guix-past
TODO: all the other channels: bimbs, etc.

# Cluster Usage

# Outreach and User Support

![Containers are like smoothies.](https://hpc.guix.info/static/images/blog/container-smoothie.png)

Guix-HPC is in part about “spreading the word” about our approach to
reproducible software environments and how it can help further the goals
of reproducible research and high-performance computing development.
This section summarizes articles, talks, and training sessions given
this year.

## Articles

TODO

We have published [7 articles on the Guix-HPC
blog](https://hpc.guix.info/blog/) touching topics such as 
fast relocatable packs, Software Heritage integration, and a
hands-on tutorial using Guix for reproducible workflows and computations.

## Talks

Since last year, we gave the following talks at the following venues:

TODO

We also organised:

 - an online [reproducible research
   hackathon](https://hpc.guix.info/blog/2020/07/reproducible-research-hackathon-experience-report),
   where 15 people were connected to tackle issues inspired by contributions
   from the [Ten Years Reproducibility
   Challenge](https://rescience.github.io/ten-years/) organized by
   [ReScience](https://rescience.github.io/);
 - the first [online GNU Guix
Day](https://guix.gnu.org/en/blog/2020/online-guix-day-announce-2), which
attracted more than 50 people all around the world;
 - [GNU Guix Days](https://libreplanet.org/wiki/Group:Guix/FOSDEM2021)

## Training Sessions

TODO

# Personnel

TODO: Double-check!

GNU Guix is a collaborative effort, receiving contributions from more
than 60 people every month—a 50% increase compared to last year.  As
part of Guix-HPC, participating institutions have dedicated work hours
to the project, which we summarize here.

  - CNRS: 0.25 person-year (Konrad Hinsen)
  - Inria: 2 person-years (Ludovic Courtès, Maurice Brémond,
    and the contributors to the
    Guix-HPC channel: Florent Pruvost, Gilles Marait, Marek Felsoci,
    Emmanuel Agullo, Adrien Guilbaud)
  - Max Delbrück Center for Molecular Medicine (MDC): 2 person-years
    (Ricardo Wurmus and Mădălin Ionel Patrașcu)
  - Tourbillion Technology: 0.7 person-year (Paul Garlick)
  - Université de Paris: 0.5 person-year (Simon Tournier)
  - University of Tennessee Health Science Center (UTHSC): 0.8
    person-year (Efraim Flashner and Pjotr Prins)
  - Utrecht Bioinformatics Center (UBC): 1 person-year (Roel Janssen)

# Perspectives
