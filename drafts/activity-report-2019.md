title: Guix-HPC Activity Report, 2019
author: Ludovic Courtès, Konrad Hinsen
date: 2020-02-12 14:00
slug: guix-hpc-activity-report-2019
---
_This document is also available as
[PDF](https://hpc.guix.info/static/doc/activity-report-2019.pdf)
([printable
booklet](https://hpc.guix.info/static/doc/activity-report-2019-booklet.pdf))._

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
[Cray, Inc.](https://www.cray.com) and [Tourbillion
Technology](http://tourbillion-technology.com/).

This report highlights key achievements of Guix-HPC between [our
previous
report](https://hpc.guix.info/blog/2019/02/guix-hpc-activity-report-2018/)
a year ago today, February 2020.

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

Supporting reproducible research in general remains a major goal for
Guix-HPC.  The ability to _reproduce_ and _inspect_ computational
experiments—today’s lab notebooks—is key to establishing a rigorous
scientific method.  We believe that a prerequisite for this is the
ability to reproduce and inspect the software environments of those
experiments.  We have made further progress to ensure Guix addresses
this use case.

## Better Support for Reproducible Research

Guix has always supported reproducible computations by design, but there were two obstacles to using Guix for actually doing reproducible computations:
  1. the user interface to reproducibility features was a bit clumsy
  2. documentation, both practical and background, was scarce

Supporting reproducible computations requires addressing four aspects:
 1. Finding the dependencies of a computation.
 2. Ensuring that there are no hidden dependencies, such as
    utility programs from the environment that are "just there".
 3. Providing a record of the dependencies from which they can be
    reconstructed.
 4. Reproducing a computation from such a record.

Step 1 is very situation-dependent and can therefore not be fully automatized. Step 2 is supported by [`guix environment`](https://guix.gnu.org/manual/en/guix.html#Invoking-guix-environment), step 3 by [`guix describe`](https://guix.gnu.org/manual/en/guix.html#Invoking-guix-describe). Step 4 used to require a rather unintuitive form of [`guix pull`](https://guix.gnu.org/manual/en/guix.html#Invoking-guix-pull) (whose main use case is updating Guix), but is now supported in a more straightforward way by `guix time-machine`, which provides direct access to older versions of Guix and all the packages it defines.

A [post on the Guix HPC blog](https://hpc.guix.info/blog/2020/01/reproducible-computations-with-guix/) explains how to perform the four steps of reproducible computation, and also explains how Guix ensures bit-for-bit reproducibility through comprehensive dependency tracking.

## Packaging

# Cluster Usage

# Outreach and User Support

# Personnel

TODO: Double-check!

GNU Guix is a collaborative effort, receiving contributions from more
than 60 people every month—a 50% increase compared to last year.  As
part of Guix-HPC, participating institutions have dedicated work hours
to the project, which we summarize here.

  - Cray, Inc.: 0.4 person-year (Eric Bavier)
  - Inria: 3 person-years (Ludovic Courtès and the contributors to the
    Guix-HPC channel: Florent Pruvost, Gilles Marait, Marek Felsoci,
    Emmanuel Agullo, Adrien Guilbaud, and others)
  - Max Delbrück Center for Molecular Medicine (MDC): 2 person-years
    (Ricardo Wurmus)
  - Tourbillion Technology: 0.5 person-year (Paul Garlick)
  - University of Tennessee Health Science Center (UTHSC): 0.3
    person-year (Pjotr Prins)
  - Utrecht Bioinformatics Center (UBC): 1 person-year (Roel Janssen)

# Perspectives
