title: Guix-Jupyter 0.2.1 released!
slug: guix-jupyter-0.2.1-released
date: 2021-01-25 16:00
author: Ludovic Courtès
tags: Research, Reproducibility, Jupyter
---

We are pleased to announce
[Guix-Jupyter 0.2.1](https://gitlab.inria.fr/guix-hpc/guix-kernel), a
new release of our Guix-powered Jupyter kernel for self-contained and
reproducible notebooks.

![Guix-Jupyter logo.](https://hpc.guix.info/static/images/blog/guix-jupyter/guix-jupyter.png)

Truth be told, participants in the [User Support Tools for
HPC](https://calcul.math.cnrs.fr/2021-01-anf-ust4hpc-2021.html) workshop
earlier today were (un)lucky enough to use the short-lived 0.2.0 release
where they uncovered a bug in a multi-user setup, which 0.2.1
[fixes](https://gitlab.inria.fr/guix-hpc/guix-kernel/-/commit/e0f69d795ccab6341b7a0756a3c4352b98f885fd).

# Getting it

You can obtain it [straight from
Guix](https://hpc.guix.info/package/guix-jupyter) and spawn Jupyter
Notebook with:

```sh
guix environment --ad-hoc jupyter guix-jupyter -- jupyter notebook
```

Alternatively, you can get the source [from
Git](https://gitlab.inria.fr/guix-hpc/guix-kernel):

```sh
git clone https://gitlab.inria.fr/guix-hpc/guix-kernel guix-jupyter
cd guix-jupyter
git checkout v0.2.1  # or a887e449cbf248113b25eac05507bd949c826554
git tag -v v0.2.1
```

# What’s new?

We [announced
Guix-Jupyter](https://hpc.guix.info/blog/2019/10/towards-reproducible-jupyter-notebooks/)
a bit more than a year ago with the goal of:

  1. Making notebooks _self-contained_ or “deployment-aware”, so that they
     automatically deploy the software (and data!) that they
     need—effectively treating software deployment and data as a
     first-class input to the computation described in the notebook.
  2. Making said _deployment bit-reproducible_: run the notebook on one
     machine or another, today or two years from now, and be sure it’s
     running in the exact same software environment.  We’re building on
     Guix support for [reproducible
     builds](https://reproducible-builds.org) and for
     [“time](https://guix.gnu.org/en/blog/2018/multi-dimensional-transactions-and-rollbacks-oh-my/)
     [travel”](https://guix.gnu.org/manual/en/html_node/Invoking-guix-time_002dmachine.html).

That very first version demonstrated what can be achieved, and it
addressed what remains a very relevant issue in the Jupyter world—if in
doubt, just try to run a notebook from one of the many
[galleries](https://github.com/jupyter/jupyter/wiki/A-gallery-of-interesting-Jupyter-Notebooks)
[out there](https://notebooks.gesis.org/gallery/).

This new version polishes various user interface aspects.  New `;;guix
describe` and `;;guix search` “magic” commands have been added,
providing the same functionality as the same-named `guix` commands.

![Guile picture language in a notebook.](https://hpc.guix.info/static/images/blog/guix-jupyter/describe-search.gif)

`;;guix environment` and `;;guix pin` commands entail software
deployment.  Depending on whether the requested software packages or
Guix revision are already in cache, downloading and/or building
everything that’s needed can take time.  Build and download progress is
now reported in the cell that triggered it, which improves the user
experience.

Various bugs and glitches such as graceless error handling have also
been fixed.

Last but not least: users of the built-in
[GNU Guile](https://gnu.org/software/guile) will enjoy its ability to
render SVG images produced by the [picture
language](https://hpc.guix.info/package/guile-picture-language).

![Guile picture language in a notebook.](https://hpc.guix.info/static/images/blog/guix-jupyter/guile-picture-language.gif)

# Enjoy!

Please let us know about [issues or improvements you’ve
made](https://gitlab.inria.fr/guix-hpc/guix-kernel/-/issues), and get in
touch with us on [the `guix-science` mailing
list](https://lists.gnu.org/mailman/listinfo/guix-science) or on the
usual [Guix communication channels](https://guix.gnu.org/en/contact/)!
