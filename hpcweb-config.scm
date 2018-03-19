;; Configuration of hpcguix-web for use on
;; "https://guix-hpc.bordeaux.inria.fr/browse".

(use-modules (hpcweb-configuration))

(define site-config
  (hpcweb-configuration
   (title-prefix "Guix-HPC — ")
   (package-filter-proc (const #t))
   (package-page-extension-proc (const '()))
   (menu '(("/about"   "ABOUT")
           ("/browse"  "BROWSE")
           ("/blog"    "BLOG")))))
