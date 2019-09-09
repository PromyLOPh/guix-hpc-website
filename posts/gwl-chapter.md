title: Chapter of “Evolutionary Genomics” on workflow tools and Guix
date: 2019-09-09 14:30
author: Ludovic Courtès
tags: Workflows, Research, Reproducibility, Bioinformatics
---

The book [_Evolutionary
Genomics_](https://link.springer.com/book/10.1007/978-1-4939-9074-0) was
published in July this year.  Of particular interest to Guix-HPC is the
chapter entitled [“Scalable Workflows and Reproducible Data Analysis for
Genomics”](https://link.springer.com/protocol/10.1007%2F978-1-4939-9074-0_24),
by Francesco Strozzi _et al._:

> In this chapter we show how to describe and execute the same analysis
> using a number of workflow systems and how these follow different
> approaches to tackle execution and reproducibility issues. We show how
> any researcher can create a reusable and reproducible bioinformatics
> pipeline that can be deployed and run anywhere. We show how to create a
> scalable, reusable, and shareable workflow using four different workflow
> engines: the Common Workflow Language (CWL), Guix Workflow Language
> (GWL), Snakemake, and Nextflow. Each of which can be run in parallel.
> 
> We show how to bundle a number of tools used in evolutionary biology by
> using Debian, GNU Guix, and Bioconda software distributions, along with
> the use of container systems, such as Docker, GNU Guix, and
> Singularity. Together these distributions represent the overall majority
> of software packages relevant for biology, including PAML, Muscle,
> MAFFT, MrBayes, and BLAST. By bundling software in lightweight
> containers, they can be deployed on a desktop, in the cloud, and,
> increasingly, on compute clusters.

The section devoted to the [GNU Guix Workflow
Language](https://www.guixwl.org) (GWL) describes the novel approach
that the GWL has been exploring:

> The Guix Workflow Language (GWL) extends the functional package
> manager GNU Guix with workflow management capabilities. GNU Guix
> provides an embedded domain-specific language (EDSL) for packages and
> package composition. GWL extends this EDSL with processes and process
> composition.
>
> […]
>
> The tight coupling of GWL and GNU Guix ascertains that not only the
> workflow is described rigorously but also the deployment of the
> programs on which the workflow depends.

Tight integration of reproducible software deployment with higher-level
tools, such as workflow tools, has been the topic of a FOSDEM 2018 talk
we gave, entitled [_Tying software deployment to scientific
workflows_](https://archive.fosdem.org/2018/schedule/event/guix_workflows/)
in 2018.  While we’re still in the early days of implementing it, we
believe that this approach is promising and may well be key to future
reproducible science tool chains.

![GWL logo.](https://hpc.guix.info/static/images/blog/gwl-logo.png)

A lot of work has gone into the GWL since that chapter was written.
Among other things, the maintainers, Roel Janssen and Ricardo Wurmus,
have added support for a [Python-like
syntax](https://www.guixwl.org/getting-started) (using
[Wisp](https://www.draketo.de/english/wisp)) that should look familiar
to many bioinformaticians.  [Check it out!](https://www.guixwl.org/)
