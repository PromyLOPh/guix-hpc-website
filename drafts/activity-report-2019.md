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
a year ago and today, February 2020.

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

Step 1 is very situation-dependent and can therefore not be fully automatized. Step 2 is supported by [`guix environment`](https://guix.gnu.org/manual/devel/en/html_node/Invoking-guix-environment.html), step 3 by [`guix describe`](https://guix.gnu.org/manual/devel/en/html_node/Invoking-guix-describe.html). Step 4 used to require a rather unintuitive form of [`guix pull`](https://guix.gnu.org/manual/devel/en/html_node/Invoking-guix-pull.html) (whose main use case is updating Guix), but is now supported in a more straightforward way by [`guix time-machine`](https://guix.gnu.org/manual/devel/en/html_node/Invoking-guix-time_002dmachine.html), which provides direct access to older versions of Guix and all the packages it defines.

A [post on the Guix HPC blog](https://hpc.guix.info/blog/2020/01/reproducible-computations-with-guix/) explains how to perform the four steps of reproducible computation, and also explains how Guix ensures bit-for-bit reproducibility through comprehensive dependency tracking.

## Reproducible Deployment for Jupyter Notebooks

[Jupyter Notebooks](https://jupyter.org) have become a tool of choice
for scientists willing to share and reproduce computational experiments.
Yet, nothing in a notebook specifies which software packages it relies
on, which puts reproducibility at risk.

Together with Pierre-Antoine Rouby as part of a four-month internship at
Inria in 2018, [we started work on
Guix-Jupyter](https://hpc.guix.info/blog/2019/02/guix-hpc-activity-report-2018/),
a Guix “kernel” for Jupyter Notebook.  In a nutshell, Guix-Jupyter
allows notebook writers to specify the software environment the notebook
depends on: the Guix packages, and the Guix commit.  Furthermore, all
the code in the notebook runs in an isolated environment (a
“container”).  This ensures that someone replaying the notebook will run
it in the right environment as the author intended.

Guix-Jupyter reached its [first release in October
2019](https://hpc.guix.info/blog/2019/10/towards-reproducible-jupyter-notebooks/).
Many on Jupyter fora were enthusiastic about this approach.  Compared to
other approaches, which revolve around building container images,
Guix-Jupyter addresses the deployment problem at its root, providing a
maximum level of transparency.

## Ensuring Source Code Availability

In April 2019, Software Heritage and GNU Guix [announced their
collaboration](https://www.softwareheritage.org/2019/04/18/software-heritage-and-gnu-guix-join-forces-to-enable-long-term-reproducibility/)
to enable long-term reproducibility.  Being able to rely on a long-term
source code archive is crucial to support the use cases that matter to
reproducible science: what good would it be if `guix time-machine` would
fail because upstream source code vanished?  Starting from beginning of
2019, Guix is [able to fall back to Software
Heritage](https://hpc.guix.info/blog/2019/03/connecting-reproducible-deployment-to-a-long-term-source-code-archive/)
should upstream source code vanish.

We worked to improve coverage of the Software Heritage archive—making
sure source code Guix packages refer to is archived.  That led to the
addition of an `archival` tool to [`guix
lint`](https://guix.gnu.org/manual/devel/en/html_node/Invoking-guix-lint.html),
our helper for package developers, which instructs Software Heritage to
archive source code it currently lacks, before the package even makes it
in Guix itself.  We helped review work carried out by NixOS developer
“lewo” to [further improve archive
coverage](https://forge.softwareheritage.org/D2025/new/).

## Packaging

The message passing interface (MPI) is a key component for our HPC users
and an important factor for the performance of multi-node parallel
applications.  We have worked on improving Open MPI support on for wide
range or high-speed network devices, making sure it can our `openmpi`
package achieves peak performance _by default_ on each of them—it is all
about _portable performance_.  This work is described in our blog post
entitled [_Optimized and portable Open MPI
packaging_](https://hpc.guix.info/blog/2019/12/optimized-and-portable-open-mpi-packaging/).
It led to improvements in packages for the high-speed network drivers
and fabrics, such as UCX, PSM, and PSM2, improvements in the Open MPI
package itself, and the addition of a package for the [Intel MPI
Benchmarks](https://software.intel.com/en-us/articles/intel-mpi-benchmarks).

TODO: List other key packages such as FeNICS?

Many other key HPC packages have been added, upgraded, or improved,
including the SLURM batch scheduler, the HDF5 data management suite, the
LAPACK reference linear algebra package, the Julia programming language,
and many more.

In addition to the packages in core Guix, we have been developing
[_channels_](https://guix.gnu.org/manual/devel/en/html_node/Channels.html)
providing packages that are closely related to the research work of
teams at our institutes.  One such example is [the Guix-HPC
channel](https://gitlab.inria.fr/guix-hpc/guix-hpc/), developed by HPC
research teams at Inria, and which now contains about forty packages.

TODO: Other channels?

# Cluster Usage

TODO: More clusters here?  UTHSC?

This year Guix has become the deployment tool of choice on more
clusters.  We are notably aware of deployments at several academic
clusters such as [GriCAD](https://gricad.univ-grenoble-alpes.fr/)
(France) and [CCIPL](https://ccipl.univ-nantes.fr/) (France).
Discussions are on-going with other academic and industrial partners who
have shown interest in deploying Guix.

We have further improved [`guix
pack`](https://guix.gnu.org/manual/devel/en/html_node/Invoking-guix-pack.html)
to support users who wish to take advantage of Guix while deploying
software on machines where Guix is not available.  One noteworthy
improvement is the addition of the `-RR` option, which we like to refer
to as “really relocatable”: `guix pack -RR` would create a relocatable
tarball that automatically falls back to using
[PRoot](https://github.com/proot-me/PRoot) for relocation [when
unprivileged user namespaces are not
supported](https://hpc.guix.info/blog/2017/10/using-guix-without-being-root/),
thereby providing a “universal” relocatable archive.  The Docker and
Singularity back-ends of `guix pack` have also seen improvements, in
particular the addition of the `--entry-point` option to specify the
default entry point, and that of a `--save-provenance` option to save
provenance meta-data in the container image.

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
  - Université de Paris: 0.5 person-year (Simon Tournier)
  - CNRS: 0.5 person-year (Konrad Hinsen)

# Perspectives
