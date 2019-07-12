;; Configuration of hpcguix-web for use on "https://hpc.guix.info/browse".

(use-modules (hpcweb-configuration))

(define site-config
  (hpcweb-configuration
   (title-prefix "Guix-HPC — ")
   (package-filter-proc (const #t))
   (package-page-extension-proc (const '()))
   (menu '(("/about"   "ABOUT")
           ("/browse"  "BROWSE")
           ("/blog"    "BLOG")))))
