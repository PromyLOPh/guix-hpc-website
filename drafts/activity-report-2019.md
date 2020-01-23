title: Guix-HPC Activity Report, 2019
author: Konrad Hinsen
date: 2020-02-12 14:00
slug: guix-hpc-activity-report-2019
---

# Better support for reproducible research

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
