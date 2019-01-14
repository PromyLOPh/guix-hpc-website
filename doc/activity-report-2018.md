*DRAFT* Guix-HPC Activity Report, 2018
=================================

# Preface

Guix-HPC is a collaborative effort to bring reproducible software
deployment to scientific workflows and high-performance computing (HPC).
Guix-HPC builds upon the [GNU Guix](https://www.gnu.org/software/guix/)
software deployment tool and aims to make it a better tool to HPC
practitioners and scientists concerned with reproducible research.

Guix-HPC was launched in September 2017 as a joint software development
project involving three research institutes:
[Inria](https://www.inria.fr/en/centre/bordeaux/news/towards-reproducible-software-environments-in-hpc-with-guix),
the [Max Delbrück Center for Molecular Medicine
(MDC)](https://www.mdc-berlin.de/), and the [Utrecht Bioinformatics
Center (UBC)](https://ubc.uu.nl/).  GNU Guix for HPC and reproducible
science has received contributions from additional individuals and
organizations, including [Cray, Inc.](https://www.cray.com) and
[Tourbillion Technology](http://tourbillion-technology.com/).

This report highlights key achievements of Guix-HPC between its launch
date in September 2017 and today, December 2018.

# Outline

Guix-HPC started up with the following high-level objectives for the
2017–2018 period:

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

Research heavily depends on computational results, which in turn depends
on the ability to reproduce software environments.  As key scientific
organizations such as the Association for Computer Machinery (ACM) and
the Nature scientific journals begin requiring authors to publish code
alongside their scientific articles, reproducing software environments
remains difficult.

GNU Guix offers a way to address these issues that does not suffer from
the opacity and lack of reproducibility of “container-based” solutions
such as Docker or Singularity.

## Software Environment Version Control

In June 2018, we developed tools to aid users who wish to have tight
control over their software environments.  The `guix pull` command can
now be used to deploy a specific revision of Guix, and `guix describe`
provides information about the currently used revision.  Along with the
new _channels_ facility, which allows users to obtain software packages
from third-party repositories, this offers a transparent way to
replicate a Guix setup, as [explained in the release notes of version
0.16.0](https://guix-hpc.bordeaux.inria.fr/blog/2018/12/hpc-reproducible-research-in-guix-0-16-0/).
Better yet, Guix allows mixing software packages coming from different
Guix revisions through a new mechanism called _inferiors_.

With the help of the [Software Heritage](https://softwareheritage.org)
engineers, we designed and implemented a back-end [that allows Guix to
fetch source code from Software
Heritage](https://issues.guix.info/issue/33432).  Software Heritage is a
persistent source code archive that preserves complete source code
repository histories.  This functionality thus allows Guix to retrieve
source code even if the original source code repository vanished or got
corrupted—an obvious requirement to reproduce software environments.  To
our knowledge this makes Guix the first software deployment tool backed
by a persistent and reliable source code archive.

GNU Guix is involved in the [Reproducible
Builds](https://reproducible-builds.org) effort.  In 2018 we were again
present at the Summit, along with a dozen of other projects concerned
with software deployment.  Together we worked to further reproducible
builds [and take advantage of
them](https://www.gnu.org/software/guix/blog/2018/reproducible-builds-summit-4th-edition/).
This is ground work that, we believe, is key to enabling reproducible
scientific workflows.

## Reproducible Pipelines

  - TODO: PiGx article by Ricardo et al.
  - TODO: Guix Workflow Language by Roel et al.
  - TODO: hpcguix-web

[Jupyter Notebooks](https://jupyter.org) have become a tool of choice
for scientists willing to share, and hopefully reproduce computational
experiments.  Yet, nothing in a notebook specifies which software
packages it relies on, which puts reproducibility at risk.  For example,
a notebook might rely on Python 3 and a specific version of NumPy and
Scipy; if someone receives the notebook and tries to execute it with,
say, Python 2 and another version of NumPy and SciPy, the result may
well be different, or execution might fail altogether.  To address this,
during a 4-month internship at Inria, Pierre-Antoine Rouby implemented a
prototype [Guix “kernel” for
Jupyter](https://gitlab.inria.fr/guix-hpc/guix-kernel).  In a nutshell,
the kernel allows notebook writers to precisely specify the software
environment the notebook depends on: the Guix packages, and the Guix
commit.  This ensures that someone replaying the notebook will run it in
the right environment as the author intended.

The GWL and the Guix Jupyter kernel take the same approach: making
reproducible software deployment a built-in feature of a larger tool.
While there are other beneficial ways to integrate Guix into existing
tools, as demonstrated by work on PiGx, we believe tight integration of
software deployment and “workflow execution” is a novel and powerful
approach that we will keep exploring.

## Packaging

Since the Guix-HPC effort was started in September 2017, around 3,000
packages were added to Guix itself; of these many had to do with linear
algebra, computational fluid dynamics, bioinformatics, and statistics,
as reported in the HPC release notes on the [Guix-HPC
blog](https://guix-hpc.bordeaux.inria.fr/blog).

In addition, our institutes have developed their own package
collections, sometimes as a staging area before packages are reviewed
and integrated in Guix proper:

  - The [Guix-HPC repository](https://gitlab.inria.fr/guix-hpc/guix-hpc)
    currently contains packages for HPC tools and run-time support
    and linear algebra libraries developed by research teams
    at [Inria](https://www.inria.fr/en/).
  - The [Guix-BIMSB repository](https://github.com/BIMSBbioinfo/guix-bimsb)
    currently contains packages for bioinformatics tools and package
    variants used at the
    [Berlin Institute for Medical Systems Biology](https://www.mdc-berlin.de/bimsb)
    of the
    [Max Delbrück Center for Molecular
    Medicine](https://www.mdc-berlin.de).
  - This [UMCU Genetics
    repository](https://github.com/UMCUGenetics/guix-additions) has more
    bioinformatics packages in use at the [Center for Molecular Medicine
    at UMC
    Utrecht](http://www.umcutrecht.nl/en/Research/Research-centers/Center-for-Molecular-Medicine).
  - The [ACE repository](https://github.com/Ecogenomics/ace-guix)
    provides packages used by the [Australian Centre for
    Ecogenomics](http://ecogenomic.org/).
  - This [Genenetwork
    repository](https://gitlab.com/genenetwork/guix-bioinformatics)
    contains bioinformatics and HPC packages used by
    [Genenetwork](http://genenetwork.org/).

These package collections, along with the curated package set that comes
with Guix (almost 9,000 packages), cover a wide range of HPC use cases.

# Cluster Usage

GNU Guix has been deployed on clusters at our research institutes and in
other places. One of our first task has been to simplify the deployment
and installation of Guix on clusters, providing new features for
distributed setups to its build daemon and command-line tools, and
[documenting the installation process for system
administrators](https://guix-hpc.bordeaux.inria.fr/blog/2017/11/installing-guix-on-a-cluster/).
This is the option we recommend because it gives cluster users a lot of
flexibility: each user can install, upgrade, and remove packages at
will, create software environments on the fly with `guix environment`,
and so on.

However, scientists may also need to target clusters where Guix is not
installed, and we wanted to offer interoperability with those.  As
so-called “container-based solutions” like Docker and Singularity are
being deployed on clusters, we developed `guix pack`, a [tool that can
create “container
images”](https://guix-hpc.bordeaux.inria.fr/blog/2017/10/using-guix-without-being-root/).
In this setup, users use `guix pack` on their laptop to generate an
image that contains precisely the software environment they need, and
then send it over to the cluster to run their application.  `guix pack`
can generate images usable by both Singularity and Docker; it can also
generate [tarballs containing relocatable
executables](https://www.gnu.org/software/guix/blog/2018/tarballs-the-ultimate-container-image-format/).
This interoperability tool allows users to not give up on the
reproducibility, transparency, and flexibility benefits offered by Guix.

  - TODO: hpcguix-web, explain customization in Utrecht

# Outreach and user support

## Articles

  - [Code Staging in GNU Guix](https://hal.inria.fr/hal-01580582/en),
    Ludovic Courtès, Oct. 2017
  - [Scientific Data Analysis Pipelines and
    Reproducibility](https://medium.com/@aakalin/scientific-data-analysis-pipelines-and-reproducibility-75ff9df5b4c5),
    Altuna Akalin, Oct. 2018
  - [Reproducible Genomics Analysis Pipelines with
    GNU Guix](https://doi.org/10.1101/298653), Ricardo Wurmus et al,
    Dec. 2018

## Conferences

  - FOSDEM 2017
  - EasyBuild User Days 2018
  - FOSDEM 2018
  - GigaScience, China (Oct. 2018, Ricardo Wurmus)

## Talks

  - CERN (May 2018; ~20 people + video; invited talk)
  - Software development plenary, Inria, May 2018
  - [JCAD](https://jcad2018.sciencesconf.org/resource/page/id/7)
    (Nov. 2018; ~100 people + streaming)
  - Nairobi (Pjotr Prins, May 2018)
  - INRA Toulouse (Feb. 2019)

## Training sessions

  - Utrecht?
  - MDC (? 2018)
  - Inria Bordeaux (Mar. 2018)
  - Inria Bordeaux (Oct. 2018)
  - URFIST, Bordeaux (Nov. 2018)

## Blog articles

  - Pre-built binaries vs. performance
  - Installing Guix on a cluster
  - Guix-HPC at FOSDEM
  - Guix-HPC debut!
  - Using Guix Without Being root
  - HPC goodies in Guix 0.14.0
  - HPC goodies in Guix 0.15.0
  - Paper on reproducible bioinformatics pipelines with Guix
  - Reproducibility vs. root privileges
  - HPC & reproducible research in Guix 0.16.0

## Media coverage

  - [Towards reproducible software environments in HPC with
    Guix](https://www.inria.fr/en/centre/bordeaux/news/towards-reproducible-software-environments-in-hpc-with-guix),
    Sept. 2017
  - [Project Adapts Reproducibility Software for HPC
    Environments](https://www.hpcwire.com/off-the-wire/free-software-helps-tackle-reproducibility-problem/),
    Sept. 2017

# Personnel

GNU Guix is a collaborative effort, receiving contributions from more
than 40 people every month.  As part of Guix-HPC though, participating
institutions have dedicated work hours to the project, which we
summarize here.

  - development, leadership, and support:
    - Cray, Inc.: ? person·year (Eric Bavier)
    - Inria: 2 person·year (Ludovic Courtès)
    - MDC: 2 person·year (Ricardo Wurmus)
    - Pjotr (affiliation?): 2(?) person·year (Pjotr Prins)
    - UBC: 2(?) person·year (Roel Janssen)
  - internships
    - Inria: 4 person·months (Pierre-Antoine Rouby)
    - ?

# Funding and Support (FIXME: remove?)

  - hardware and hosting
    - MDC: build farm (25 machines)
    - Inria: Guix-HPC web server (1 machine)
  - training sessions
  - conference travel expenses(?)
