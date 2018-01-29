title: Guix-HPC at FOSDEM
author: Ludovic Courtès
date: 2018-01-29 16:00
tags: FOSDEM
---

GNU Guix [will be present at
FOSDEM](https://www.gnu.org/xxx-blog-post-fosdem), the main yearly free
software developer conference in Europe, and in particular in the [HPC
track](https://fosdem.org/2018/schedule/track/hpc,_big_data,_and_data_science/).

Last year, Pjotr Prins and I gave [a general
overview](https://archive.fosdem.org/2017/schedule/event/hpc_deployment_guix/)
of Guix in HPC and how it differs from other solutions.  This year’s
talk, entitled [_Tying software deployment to scientific workflows—Using
Guix to make software deployment a first-class
citizen_](https://fosdem.org/2018/schedule/event/guix_workflows/), will
cover topics beyond mere “package management”:

> Package management, container provisioning, and workflow execution are
> often viewed as related but separate activities.  This talk is about
> using Guix to integrate reproducible software deployment in scientific
> workflows.
>
> In HPC, tools usually focus exclusively on one of these aspects: Spack
> or EasyBuild manage packages, Singularity or Shifter deal with
> containers, and SLURM, CWL, or Galaxy mostly leave it up to users to
> deploy their software.
>
> While the initial tooling of GNU Guix is about package management, we
> have grown it into a toolkit that, broadly speaking, allows developers
> to integrate reproducible software deployment into their
> applications—as opposed to leaving it up to the user.
>
> In this talk I will illustrate the benefits of this approach with
> examples from recent work from the Guix-HPC effort. This ranges from
> the `guix pack` container provisioning tool, to the [Guix Workflow
> Language](http://guixwl.org) (GWL), which incorporates deployment as a
> key aspect of workflow management.  I will discuss how we could make
> these tools key components of broader reproducible scientific
> workflows as demonstrated by projects such as
> [ActivePapers](http://www.activepapers.org/),
> [ReScience](https://rescience.github.io/), or
> [NextJournal](https://nextjournal.com/).

The HPC track is full of exciting talks about software deployment, in
particular by developers of
[EasyBuild](https://easybuilders.github.io/easybuild/),
[Spack](https://spack.io/), and
[Modules](http://modules.sourceforge.net/), and experience reports
notably around [Nix](https://nixos.org/nix/).  The track opens with a
[talk by Kenneth Hoste of
EasyBuild](https://fosdem.org/2018/schedule/event/installing_software_for_scientists/),
who will bravely attempt to summarize the key differences between all
these tools.

Additionally, Kenneth kindly invited us to the [3rd EasyBuild User
Meeting](https://github.com/easybuilders/easybuild/wiki/3rd-EasyBuild-User-Meeting),
which takes place before FOSDEM.  Ricardo Wurmus and Pjotr Prins will
share their experience using Guix in HPC with users and developers of
EasyBuild and related tools.

An exciting week for software deployment in HPC!
