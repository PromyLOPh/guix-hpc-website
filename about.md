title: About
---

Guix-HPC is an effort to optimize [GNU Guix](https://gnu.org/s/guix) for
_reproducible scientific workflows in high-performance computing_ (HPC).
Our [introductory article](/blog/2017/09/guix-hpc-debut) explains how we got
started and gives an overview of what we want to achieve.  We
regularly publish [articles](/blog) on this Web site highlighting specific
features or achievements.  Stay tuned!

Guix-HPC is a joint software development project currently involving
three research institutes: [Inria](https://www.inria.fr/en/centre/bordeaux/news/towards-reproducible-software-environments-in-hpc-with-guix),
the
[Max Delbrück Center for Molecular Medicine (MDC)](https://www.mdc-berlin.de/47864296/en/news/2017/20170905-wissenschaftliches-rechnen-erfolgreich-reproduzieren),
and the [Utrecht Bioinformatics Center (UBC)](https://ubc.uu.nl/reproducible-software-environments-in-hpc-with-guix/).

# Talks & Papers

The material below covers our work and motivation for Guix-HPC:

  - [_PiGx: Reproducible Genomics Analysis Pipelines with
    GNU Guix_](https://doi.org/10.1093/gigascience/giy123), GigaScience
    [ICG-13](http://www.icg-13.org/)
    ([video](https://hpc.guix.info/blog/2019/01/pigx-paper-awarded-at-the-international-conference-on-genomics-icg-13/)),
    Dec. 2018
  - [_Beyond Bundles—Reproducible Software Environments with
    GNU Guix_](https://cds.cern.ch/record/2316926), [CERN Computing
    Seminars](http://cseminar.web.cern.ch/cseminar/), May 2018
  - [_Reproducible genomics analysis pipelines with
    GNU Guix_](https://www.biorxiv.org/content/early/2018/04/11/298653),
    Apr. 2018
  - [_Tying software deployment to scientific
    workflows_](https://fosdem.org/2018/schedule/event/guix_workflows/),
    [FOSDEM](https://fosdem.org/2018/), Feb. 2018
  - [_Reproducible and user-controlled software management in HPC with GNU Guix_](https://www.youtube.com/watch?v=cH6wCL6GeOQ&list=PLir-OOQiOhXZX_2zmUJz0fx8RLALi3tkK&index=26) ([PDF](https://www.gnu.org/software/guix/guix-bosc-20170724.pdf)),
    [BOSC](https://www.open-bio.org/wiki/BOSC_2017_Schedule), July 2017
  - [_Optimized and Reproducible HPC Deployment_](https://archive.fosdem.org/2017/schedule/event/hpc_deployment_guix/),
	[FOSDEM](https://fosdem.org/2017),
	Feb. 2017
  - [_Workflow Management with GNU Guix_](https://archive.fosdem.org/2017/schedule/event/guixworkflowmanagement/),
	[FOSDEM](https://fosdem.org/2017),
	Feb. 2017
  - [_Reproducible and User-Controlled Software Environments in HPC with Guix_](https://hal.inria.fr/hal-01161771/en)
    ([slides](https://www.gnu.org/software/guix/guix-reppar-20150825.pdf)),
	paper presented at the 2nd International Workshop on Reproducibility
	in Parallel Computing ([RepPar](http://www.reppar.org/2015/)),
	Aug. 2015

# Code

Most of the code developed for Guix-HPC aims to consolidate [the code
base](https://git.savannah.gnu.org/cgit/guix.git/)
and [package collection](https://gnu.org/software/guix/packages) of Guix
proper, and thus be pushed upstream.  This has already given rise to a
large collection of bioinformatics, algebra, and R packages, as well as
features to simplify Guix deployment on clusters.

Some auxiliary tools and package sets are maintained elsewhere, or kept
in a staging area until they are mature enough to be submitted for
inclusion in Guix:

  - The [Guix Workflow Language](https://www.guixwl.org/), a lightweight
    framework implementing reproducible computational pipelines.
  - [hpcguix-web](https://github.com/UMCUGenetics/hpcguix-web) is a web
    interface that allows users to search for packages and guides them
    the installation and the job submission process.
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
    [Genenetwork](http://genenetwork.org/) at the University of Tennessee.
  - The [Guix Past](https://gitlab.inria.fr/guix-hpc/guix-past)
    channel contains definitions for old core packages.

All this is [free software](https://www.gnu.org/philosophy/free-sw.html)
that you are welcome to use and contribute to!

# Cluster Deployments

Here are known deployments of Guix on clusters and contact information:

  - [Max Delbrück Center for Molecular Medicine](https://www.mdc-berlin.de) (Germany)
      - 250-node cluster + workstations
      - contact: Ricardo Wurmus
  - [Utrecht Bioinformatics Center](https://ubc.uu.nl) (The Netherlands)
      - 68-node cluster (1,000+ cores)
      - contact: Roel Janssen
  - [Australian Centre for Ecogenomics](http://ecogenomic.org/) (Australia)
      - 21-node cluster (1,000 cores)
      - contact: Ben Woodcroft
  - [PlaFRIM](https://www.plafrim.fr/en/home/) (France)
	  - 120-node heterogeneous cluster (3,000+ cores)
	  - contact: Ludovic Courtès
  - [GriCAD](https://gricad.univ-grenoble-alpes.fr/) (France)
	  - 72-node “Dahu” cluster (1,000+ cores)
	  - contact: Violaine Louvet, Pierre-Antoine Bouttier
  - [CCIPL](https://ccipl.univ-nantes.fr/) (France)
      - 230-node cluster (4,000+ cores)
      - contact: Yann Dupont
  - [UTHSC](https://uthsc.edu/) (USA)
      - 2-node test cluster (128 cores). In preparation
        of 2020 research cluster and clinical cluster
      - contact: [Pjotr Prins](http://thebird.nl/)

If you would like to be listed here, please email us at `guix-hpc@gnu.org`.

# Join us!

If you are using Guix in an HPC context at your workplace, or if you
would like to discuss ways to address your own HPC use cases, or if you are
an HPC vendor interested in improving the software deployment experience
for your users, please consider joining us!  Email us at
`guix-hpc@gnu.org`.
