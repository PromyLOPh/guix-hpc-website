title: Guix-HPC Activity Report, 2020
author: Simon Tournier, Ludovic Courtès
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
experiments.

We have made further progress to ensure Guix addresses this use case.
We work not only on deployment issues, but also _upstream_—ensuring
source code is archived at Software Heritage—and
_downstream_—devising
tools and workflows for scientists to use.

## The Guix Workflow Language

TODO: extensions

## Guix-Jupyter

We [announced
Guix-Jupyter](https://hpc.guix.info/blog/2019/10/towards-reproducible-jupyter-notebooks/)
a bit more than a year ago, with two goals: making notebooks
_self-contained_ or “deployment-aware” so that they automatically
deploy the software (and data!) that they need, and making said
deployment _bit-reproducible_.

In essence, Guix-Jupyter treats software deployment and data as a
first-class input to the computation described in the notebook.  One can
run the notebook on one machine or another, today or two years from now,
and be sure it’s running in the exact same software environment.

This Jupyter “kernel” builds on Guix support for reproducible builds and
for “time travel”.  That very first version demonstrated what can be
achieved, and it addressed what remains a very relevant issue in the
Jupyter world, as is clear to anyone who has tried to run a notebook
published in one of the many public galleries.

Version 0.2.1 was [announced in January
2021](https://hpc.guix.info/blog/2021/01/guix-jupyter-0.2.1-released/).
Among the user interface changes and bug fixes it provides, `;;guix
describe` and `;;guix search` “magic” commands have been added,
providing the same functionality as the same-named `guix` commands.
Build and download progress is now reported in the cell that triggered
it, which improves the user experience.  While we still consider it
“beta”, we believe it already smoothly covers a wide range of use cases.

## From Source Code to Research Article

TODO: illustration

GWL and Guix-Jupyter are both tools designed for a scientific audience,
as close as possible to the actual scientific experiments and workflows.
In the same vein, we participated in the [_Ten Years Reproducibility
Challenge_](https://rescience.github.io/ten-years/) organized by
ReScience C, an open-access, peer-reviewed journal that targets
computational research and encourages the replication of already
published research.

Participants were invited to pick a scientific article they had
published at least ten years earlier, and to try and reproduce its
results.  Needless to say, participants encountered many difficulties,
most of which boil down to: finding the code, getting it to build, and
getting it to run in an environment as close as possible to the original
one.

This last challenge—re-deploying software—is of particular interest to
Guix, which has to goal of supporting bit-reproducible deployments _in
time_.  Of course, the chosen articles were published before Guix even
existed, but we thought it was a good opportunity to demonstrate how
Guix will allow users to address these challenges from now on.  Among
the fifty participants, some chose to address deployment issues using
Docker or virtual machines (VMs), and several chose Guix.  The challenge
and its contributions, including a discussion of software deployment
issues and Guix, led to [an article in
_Nature_](https://www.nature.com/articles/d41586-020-02462-7) (Jeffrey
M. Perkel, _Challenge to scientists: does your ten-year-old code still
run?_, August 2020).

The [replication work by Ludovic
Courtès](https://doi.org/10.5281/zenodo.3886739) is an attempt to show
the best one could provide: a _complete_, end-to-end reproducible
research article pipeline, from source code to PDF.  The articles shows
how to bridge together code that deploys the software evaluated in the
paper, scripts that run the evaluation and produce plots, and scripts
that produce the final PDF file from LaTeX source and plots. The end
result is approximately 400 lines of code that allow Guix to rebuild the
whole article _and the experiment it depends on_ with a well-specified,
reproducible software environment.

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

This is just the beginning.  We plan to keep working closely with
scientists and journals such as ReScience C to investigate ways to make
this approach more widely applicable.

Soon after the challenge, we organized a one-day on-line hackathon to
collectively work on providing missing bits so more scientific
experiments can be reproduced.  This led to improved coverage of
historic package versions in the new [Guix-Past
channel](https://gitlab.inria.fr/guix-hpc/guix-past), which was created
for the challenge.

## Ensuring Source Code Availability

TODO: sources.json, SWH and Nix

## Package Transformations

HPC practitioners are often demanding when it comes to customizing
software they deploy: choosing dependencies, versions, build flags, and
so on.  Guix caters to these needs through its programming interfaces
but also _via_ its easy-to-use [*package transformation
options*](https://guix.gnu.org/manual/en/html_node/Package-Transformation-Options.html).

Over the past year, several of them were added.  The
`--with-c-toolchain` option allows users to build a package and all its
dependents with a given C toolchain; this is useful for those willing to
benefit from the latest improvements in optimizing compilers.  The
`--with-patch` option applies a patch to a package and rebuilds it along
with its dependent.  The `--with-debug-info` rebuilds a package in a way
that preserves its debugging info (if it wasn’t already available) and
without requiring a rebuild of its dependents.

Furthermore, package transformation options passed to `guix install` and
similar commands are now recorded in profiles and _replayed_ when
running `guix upgrade`, thereby ensuring user customization is
preserved.  Another novelty is that package transformations now apply to
“implicit inputs” (package dependencies provided by the build system),
giving users even more flexibility.

The Guix reference manual now includes a section discussing the various
[ways to define package
variants](https://guix.gnu.org/manual/en/html_node/Defining-Package-Variants.html).

## Declarative Deployment with Manifests

In addition to the “imperative” management style where one runs `guix
install` and related commands, Guix supports a _declarative_ style where
the user provides a code snippet, called a _manifest_, that describes
the packages to deploy.  The declarative approach has the advantage of
being explicit and stateless: the manifest file can be put under version
control and shared with others.  It is also flexible because users have
access to the whole programming environment of Guix from within the
manifest.

To reduce the learning curve and make it easier to switch to the
declarative style, we made two improvements.  First, users can now
export a manifest from an existing profile by running `guix package
--export-manifest`.  The output can be stored in a file and users can
switch to running `guix package --manifest` with that file right away.

Second, there is now a high-level programming interface giving access to
package transformations, with a one-to-one mapping to their command-line
syntax.  This interface can be used in manifests.  In fact, the manifest
produced by `--export-manifest` uses it when needed.

## Packaging

The package collection that comes with Guix keeps growing.  It now
contains **16,000 packages**, including many scientific packages ranging
from run-time support software such as implementations of the Message
Passing Interface (MPI), to linear algebra software, to statistics and
bioinformatics modules for R.  In addition to packages in Guix proper,
we have been maintaining _channels_, which provide additional packages,
usually specialized in one application domain.

As part of the aforementioned _Ten Years Reproducibility Challenge_ and
subsequent reproducible research hackathon, we created [the
**Guix-Past** channel](https://gitlab.inria.fr/guix-hpc/guix-past), with
the goal of collecting versions of software older than Guix itself, for
use in reproducible research experiments.  It now contains sixty
packages, including Python 2.4 (from 2008), Perl 5.14 (from 2011), and
2006-era versions of the GNU “Autotools”.  We hope this can serve as the
basis for future reproducible research endeavors.

TODO: guix-science
TODO: all the other channels: bimbs, etc.


# Cluster Usage

Over the last few years, we have been developing `guix pack` to support
users who target supercomputers where Guix is unavailable.  `guix pack`
creates “**application bundles**” as Docker or Singularity images, or as
plain self-contained tarballs.  We previously implemented _relocatable
packs_: archives that can be extracted anywhere on the file system while
still allowing users to run the software therein.  The appeal of this
option is that it allows users to run packaged software on machines that
provide neither Guix nor a container run-time.

Relocatable packs were initially implemented by using the Linux
“unprivileged user namespace” feature, with a fallback to PRoot when
unprivileged user namespaces are unavailable.  In the latter case
though, the overhead can be prohibitively high for some applications.
To address that, `guix pack` can now build [**faster relocatable
packs**](https://hpc.guix.info/blog/2020/05/faster-relocatable-packs-with-fakechroot/)
that rely on a customization of the run-time linker (`ld.so`) along with
the use of Fakechroot.  It provides the flexibility of packs with
negligible overhead.

Guix deployment on scientific clusters continues.  A notable example is
work-in-progress to support Guix out-of-the-box on
[**Grid’5000**](https://www.grid5000.fr/), a major French grid and HPC
environment.  Installing Guix on Grid’5000 is quite different from
installing it on a “regular” HPC cluster due to the unusual nature of
this environment: Grid’5000 users have the option to deploy their own
operating system images on compute nodes and have administration
privileges on them.  This has required adjustments compared to our
[cluster installation
guide](https://hpc.guix.info/blog/2017/11/installing-guix-on-a-cluster/).
This should be in production in the coming weeks.

  - TODO UTHSC?

# Outreach and User Support

![Containers are like smoothies.](https://hpc.guix.info/static/images/blog/container-smoothie.png)

Guix-HPC is in part about “spreading the word” about our approach to
reproducible software environments and how it can help further the goals
of reproducible research and high-performance computing development.
This section summarizes articles, talks, and training sessions given
this year.

## Articles

The following articles were published in the [_Ten Years Reproducibility
Challenge_ special issue of the ReScience C
journal](https://rescience.github.io/read/#issue-1-ten-years-reproducibility-challenge)
(volume 6, issue 1); they present different ways of using Guix to
reproduce the software environment associated with a past computational
experiment:

  - [_[Re] Volume computation for polytopes: Vingt ans
    après_](http://dx.doi.org/10.5281/zenodo.4242972), Andreas Enge
  - [_[Rp] Structural flexibility in proteins — impact of the crystal
    environment_](http://dx.doi.org/10.5281/zenodo.3886447), Konrad Hinsen
  - [_[Re] Storage Tradeoffs in a Collaborative Backup Service for
    Mobile Devices_](http://dx.doi.org/10.5281/zenodo.3886739), Ludovic Courtès

We published [8 articles on the Guix-HPC
blog](https://hpc.guix.info/blog/) touching topics such as fast
relocatable packs, reproducible research article workflows, and Jupyter
integration.

TODO: More articles?

## Talks

Since last year, we gave the following talks at the following venues:

  - [JDEV conference (on-line), July
    2020](http://devlog.cnrs.fr/jdev2020/t4) (Ludovic Courtès)
  - [on-line seminar of the Belgium Research Software Engineers community
    (BE-RSE), Nov. 2020](https://www.be-rse.org/seminars) (Ludovic
    Courtès)
  - [on-line Guix Days,
    Nov. 2020](https://guix.gnu.org/en/blog/2020/online-guix-day-announce-2/)
    (Lars-Dominik Braun)

We also organised the following events:

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

JDEV, the annual conference gather research engineers from all the
French research institutes and universities, [took place on-line in July
2020](http://devlog.cnrs.fr/jdev2020/t4).  It included an presentation
of Guix along with an introductory workshop.

The [_User Tools for HPC_
(UST4HPC)](https://calcul.math.cnrs.fr/2021-01-anf-ust4hpc-2021.html)
workshop took place in January 2021.  It is organized as part of the
training sessions program of the French national scientific research
center (CNRS).  It included talks and hands-on session about Guix and
Guix-Jupyter.

TODO: Anything else?

# Personnel

TODO: Double-check!

GNU Guix is a collaborative effort, receiving contributions from more
than 60 people every month—a 50% increase compared to last year.  As
part of Guix-HPC, participating institutions have dedicated work hours
to the project, which we summarize here.

  - CNRS: 0.25 person-year (Konrad Hinsen)
  - Inria: 2 person-years (Ludovic Courtès, Maurice Brémond,
    and the contributors to the
    Guix-HPC channel: Emmanuel Agullo, Florent Pruvost, Gilles Marait,
    Nathalie Furmento, Marek Felšöci, Adrien Guilbaud, Philippe
    Swartvagher, Matthieu Simonin)
  - Max Delbrück Center for Molecular Medicine (MDC): 2 person-years
    (Ricardo Wurmus and Mădălin Ionel Patrașcu)
  - Tourbillion Technology: 0.7 person-year (Paul Garlick)
  - Université de Paris: 0.5 person-year (Simon Tournier)
  - University of Tennessee Health Science Center (UTHSC): 0.8
    person-year (Efraim Flashner and Pjotr Prins)
  - Utrecht Bioinformatics Center (UBC): 1 person-year (Roel Janssen)

# Perspectives

TODO
