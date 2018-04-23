title: Pre-built binaries vs. performance
author: Ludovic Courtès
date: 2018-01-31 14:30
tags: pre-built binaries, performance, optimization
---

Guix follows a _transparent source/binary deployment model_: it will
download pre-built binaries when they’re available—like `apt-get` or
`yum`—and otherwise falls back to building from source.  Most of the
time the project’s build farm provides binaries so that users don’t have
to spend resources building from source.  Pre-built binaries may be
missing when you’re installing a custom package, or when the build farm
hasn’t caught up yet.  However, deployment of binaries is often seen as
incompatible with high-performance requirements—binaries are “generic”,
so how can they take advantage of cutting-edge HPC hardware?  In this
post, we explore the issue and solutions.

# Building portable binaries

CPU architectures are a moving target.  The x86\_64 instruction set
architecture (ISA), for instance, has a whole family of extensions—[AVX
and AVX2](https://en.wikipedia.org/wiki/Advanced_Vector_Extensions)
being the most obvious ones on x86\_64.  These extensions are often
critical for the performance of computational programs.  For example,
[fused multiply-add](https://en.wikipedia.org/wiki/FMA_instruction_set)
(FMA), which can have significant impact on some applications, was only
introduced in some relatively recent AMD and Intel processors, and new
versions of these extensions are being deployed.  Each x86\_64 machine
typically supports a subset of these extensions.

Package distributions that provide pre-built binaries—Guix, but also
Debian, Fedora, CentOS, and so on—have one important constraint: they
must provide binaries that work on _all_ the computers for the target
architecture.  Therefore, those binaries should target the _common
denominator_ of that architecture.  For x86\_64, that means _not_ using
instructions from AVX & co.  Put this way, pre-built binaries look
unattractive from an HPC viewpoint.

# Run-time selection

In Guix land, this has been the topic
[of](https://lists.gnu.org/archive/html/guix-devel/2016-10/msg00005.html)
[lengthy](https://lists.gnu.org/archive/html/guix-devel/2017-08/msg00155.html),
[discussions](https://lists.gnu.org/archive/html/guix-devel/2017-09/msg00002.html)
over the years.  Actually, distro developers know that this issue is not
new, and that this concern is not specific to HPC.  Many pieces of
software, from video players to the C library, can–and do!—greatly
benefit from some of these ISA extensions.  How do they address this
dilemma—providing portable binaries _without_ compromising on
performance?

The solution is to select the most appropriate implementation of “hot”
code at run time.  Video players like MPlayer and number-crunching
software like the [GNU multiprecision library](https://gmplib.org/) have
used this “trick” since their inception: using the
[`cpuid`](https://en.wikipedia.org/wiki/Cpuid) instruction, they can
determine _at run time_ which ISA extensions are available and branch to
routines optimized for the available extensions.  Many other
applications include similar ad-hoc mechanism.

GNU, which [runs on 100% of the Top 500
supercomputers](https://www.top500.org/statistics/list/), now provides
generic mechanisms for this in the toolchain.  First, the GNU C Library
(glibc) has always had vendor-provided optimized implementations of its
string and math routines, selected at run time.

The underlying mechanisms have been generalized in glibc in the form of
[_indirect functions_ or
“IFUNCs”](https://sourceware.org/glibc/wiki/GNU_IFUNC), which work along
these lines:

  - Application developers provide libc with a _resolver_.  A resolver
    is a function that selects the “best” optimized implementation for
    the CPU at hand and returns it.  As an example, glibc’s resolver for
    `memcmp` looks like
    [this](https://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/x86_64/multiarch/ifunc-memcmp.h).
  - Resolvers are called at load time by the run-time linker, `ld.so`,
    once for all.  Thus, selection happens only once at load time.
  - To simplify the use of IFUNCs, GCC provides [an `ifunc`
    attribute](https://gcc.gnu.org/onlinedocs/gcc-7.3.0/gcc/Common-Function-Attributes.html#index-ifunc-function-attribute)
    to decorate functions that have an associated resolver.
	
IFUNCs are starting to be used outside glibc proper, for instance by the
[Nettle](https://www.lysator.liu.se/~nisse/nettle/) cryptographic
library
([code](https://git.lysator.liu.se/nettle/nettle/blob/master/fat-setup.h#L32)),
though there are currently
[restrictions](https://sourceware.org/glibc/wiki/GNU_IFUNC#How_do_I_use_indirect_functions_in_my_own_code.3F)
to be aware of.

Better yet, [since version
6](https://developers.redhat.com/blog/2016/02/23/upcoming-features-in-gcc-6/),
GCC supports automatic [_function
multi-versioning_](https://gcc.gnu.org/wiki/FunctionMultiVersioning)
(FMV): the [`target_clones` function
attribute](https://gcc.gnu.org/onlinedocs/gcc-7.3.0/gcc/Common-Function-Attributes.html#index-target_005fclones-function-attribute)
allows users to instruct GCC to generate several optimized variants of a
function _and_ to generate a resolver to select the right one based on
the CPUID.

This [LWN article](https://lwn.net/Articles/691932/) nicely shows how
code can benefit from FMV.  The article links to [this script to
automatically annotate FMV candidates with
`target_clones`](https://github.com/clearlinux/make-fmv-patch); there’s
even a
[tutorial](https://clearlinux.org/documentation/clear-linux/tutorials/fmv)!

Problem solved?

# When upstream software lacks run-time selection

It turns out that not all software packages, especially scientific
software, use these techniques.  Some do—for instance,
[OpenBLAS](https://guix-hpc.bordeaux.inria.fr/package/openblas) supports
run-time selection when compiled with `DYNAMIC_ARCH=1`—but many don’t.
For example, [FFTW](https://guix-hpc.bordeaux.inria.fr/package/fftw)
insists on being compiled with
[`-mtune=native`](https://gcc.gnu.org/onlinedocs/gcc-7.3.0/gcc/x86-Options.html#index-mtune-15)
and provides [configuration
options](http://fftw.org/fftw3_doc/Installation-on-Unix.html#Installation-on-Unix)
to statically select CPU optimizations (*Update:* FFTW 3.3.7+ [can select
optimized routines at run time](https://lists.gnu.org/archive/html/guix-devel/2018-04/msg00091.html));
[ATLAS](https://guix-hpc.bordeaux.inria.fr/package/atlas) optimizes
itself for the CPU it is being built on.  We can always say that the
“right” solution would be to “fix” these packages upstream so that they
use run-time selection, but how do we handle these _today_ in Guix?

Depending on the situation, we have so far resorted to different
solutions.  ATLAS so heavily depends on configure-time tuning that we
simply don’t distribute pre-built binaries for it.  Instead, running
`guix package -i atlas` unconditionally builds it locally, as upstream
authors intended.

For FFTW, [BLIS](https://guix-hpc.bordeaux.inria.fr/package/blis), and
other packages where optimizations are selected at configure-time, we
simply build the generic version, like Debian and others do.  This is
the most unsatisfactory situation: we have portable binaries at the cost
of degraded performance.

However, we also programmatically provide _optimized package variants_
for these.  For BLIS, [we have a `make-blis`
function](https://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/maths.scm#n2687)
that we use to generate a
[`blis-haswell`](https://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/maths.scm?id=fddf1dc3aba3176b6efc9e0be0918245665a6ebf#n2762)
package optimized for Intel Haswell CPUs, a
[`blis-knl`](https://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/maths.scm?id=fddf1dc3aba3176b6efc9e0be0918245665a6ebf#n2767)
package, and so on.  Likewise, for FFTW, we have an [`fftw-avx`
package](https://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/algebra.scm?id=ea5624739855f1770c960859e73d3758a95b7282#n592)
that uses AVX2-specific optimizations.  We don’t provide binaries for
these optimized packages, but users can install the variant that
corresponds to their machine.

# Dependency graph rewriting

Having optimized package variants is nice, but how can users take
advantage of them?  For instance, the
[`julia`](https://guix-hpc.bordeaux.inria.fr/package/julia) and
[`octave`](https://guix-hpc.bordeaux.inria.fr/package/octave) packages
depend on the generic (unoptimized) `fftw` package—this allows us to
distribute pre-built binaries.  What if you want Octave to use the
AVX2-optimized FFTW?

One option is to _rewrite the dependency graph_ of Octave, so that
occurrences of the generic `fftw` package are replaced by `fftw`.  This
can be done from the command line [using the `--with-input`
option](https://www.gnu.org/software/guix/manual/html_node/Package-Transformation-Options.html):

```
guix package -i octave --with-input=fftw@3.3.5=fftw-avx
```

The above command does that graph rewriting.  Consequently, it ends up
building from source the part of the Octave dependency graph that
depends on `fftw`.  Not ideal because rebuilding can take a while, but
readily applicable.

When the library and its replacement (`fftw` and `fftw-avx` here) are
known to have the same application binary interface (ABI), as is the
case here, another option is to simply let the run-time linker pick up
the optimized version instead of the unoptimized one.  This can be done
by setting the `LD_LIBRARY_PATH` environment variable:

```
LD_LIBRARY_PATH=`guix build fftw-avx`/lib octave
```

Here Octave will pick the optimized `libfftw.so`.  (`/etc/ld.so.conf`
would be another possibility but the glibc package in Guix currently
ignores that file since that could lead to loading
binary-incompatible `.so` files when using Guix on a distro other than
GuixSD.)

# Where to go from here?

As we have seen, Guix does not sacrifice performance.  In the worst
case, it requires users to explicitly install optimized package
variants, which get built from source.  This is not as simple as we
would like though, so people have been looking for ways to improve the
situation.

The first option is to work with upstream software developers to
introduce run-time selection—an option that benefits everyone.  Of
course, that’s something we can always do in the background, but it
takes time.  It does work in the long run though; for instance, BLIS has
[recently introduced support for run-time
selection](https://github.com/flame/blis/issues/129).  [Like Clear
Linux](https://clearlinux.org/documentation/clear-linux/tutorials/fmv),
we can also start applying function multi-versioning based on compiler
feedback in key packages and use that as a starting point when
discussing with upstream.

Some [have
proposed](https://lists.gnu.org/archive/html/guix-devel/2017-08/msg00155.html)
making CPU features a first-class concept in Guix.  That way, one could
install with, say, `--cpu-features=avx2` and end up downloading binaries
or building binaries optimized for AVX2.  The downsides are that this
would be a big change, and that it’s not clear how to tell package build
systems to enable such or such optimizations in a generic way.

[Another option on the
table](https://lists.gnu.org/archive/html/guix-devel/2017-08/msg00194.html),
inspired by Fedora and Debian, is to provide a mechanism that makes it
easy for users to switch between implementations of an interface without
needing recompilation.  This could work for BLAS implementations or MPI
implementations that are known to have the same ABI.  Similarly, having
support for something similar to `ld.so.conf` would help—though it would
have to be per-user rather than be limited to `root`, to retain the
freedom that Guix provides to users.  Such dynamic software composition
could work against the reproducibility mantra of Guix though, since
software behavior would depend on site-specific configuration not under
Guix control.

With its transparent source/binary deployment model, Guix offers both
the advantages of pre-built binaries à la `apt-get` and that of
built-from-source, optimized software à la EasyBuild or Spack when it
must.  The challenges ahead will be to streamline that experience.
