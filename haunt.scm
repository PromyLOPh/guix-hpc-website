;;; This module is part of Guix-HPC and is licensed under the same terms,
;;; those of the GNU GPL version 3 or (at your option) any later version.
;;;
;;; Copyright © 2017 Inria

;; This is a build file for Haunt.  Run 'haunt build' to build the web site,
;; and 'haunt serve' to serve it locally.  Alternatively, you can run
;; 'guix build -f guix.scm' to have everything built in the store.
(use-modules (haunt site)
             (haunt reader)
             (haunt reader commonmark)
             (haunt page)
             (haunt html)
             (haunt utils)
             (haunt builder assets)
             (haunt builder blog)
             (haunt builder atom)
             (ice-9 match)
             (srfi srfi-1)
             (guix-hpc))

(define %local-test?
  ;; True when we're testing locally, as opposed to producing things to
  ;; install to gnu.org.
  (or (getenv "WEB_SITE_LOCAL")
      (member "serve" (command-line))))           ;'haunt serve' command

(when %local-test?
  ;; The URLs produced in these pages are only meant for local consumption.
  (format #t "~%Producing Web pages for local tests *only*!~%~%")
  (current-url-root ""))

(site #:title
      "Guix HPC — Reproducible software deployment for high-performance computing"
      #:domain "//hpc.guixsd.org/"
      #:default-metadata
      '((author . "Guix-HPC Contributors")
        (email  . "guix-devel@gnu.org"))
      #:readers (list commonmark-reader)
      #:builders
      (cons* (blog ;; #:theme %news-haunt-theme
              ;; #:prefix "news"
              )

             ;; Apparently the <link> tags of Atom entries must be absolute URLs,
             ;; hence this #:blog-prefix.
             (atom-feed #:file-name "news/feed.xml"
                        #:blog-prefix "https://hpc.guixsd.org")

             ;; (static-directory "static")

             (map (lambda (page)
                    (lambda (site posts)
                      page))
                  (static-pages))))
