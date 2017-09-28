(use-modules (guix packages)
             (guix licenses)
             (guix build-system gnu)
             (gnu packages autotools)
             (gnu packages guile)
             (gnu packages package-management))

(package
  (name "hpcguix-web")
  (version "0.1")
  (source ".")
  (build-system gnu-build-system)
  (native-inputs
   `(("autoconf" ,autoconf)
     ("automake" ,automake)))
  (inputs
   `(("guile" ,guile-2.2)
     ("guile-json" ,guile-json)
     ("guix" ,guix)))
  (synopsis "Support web interface for GNU Guix on a cluster")
 (description "This package provides a web interface for GNU Guix to
search packages, how-to instructions, examples and usage recommendations.")
 (home-page "https://gitorious.org/guix-web/guix-web")
 (license agpl3+))
