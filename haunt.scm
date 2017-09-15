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
             (haunt post)
             (haunt page)
             (haunt html)
             (haunt utils)
             (haunt builder assets)
             (haunt builder blog)
             (haunt builder atom)
             (ice-9 match)
             (srfi srfi-1)
             (srfi srfi-19)
             (guix-hpc))

(define %web-site-title
  "Guix-HPC — Reproducible software deployment for high-performance computing")

(define* (post->sxml post #:key post-uri)
  "Return the SXML for POST."
  `(div (@ (class "post"))
        (h2 (@ (class "title"))
            ,(if post-uri
                 `(a (@ (href ,post-uri))
                     ,(post-ref post 'title))
                 (post-ref post 'title)))
        (div (@ (class "post-about"))
             ,(post-ref post 'author)
             " — " ,(date->string (post-date post) "~B ~e, ~Y"))
        (hr)
        (div (@ (class "post-body"))
             ,(post-sxml post))))

(define (page->sxml site title posts prefix)
  "Return the SXML for the news page of SITE, containing POSTS."
  `((div (@ (class "header"))
         (div (@ (class "post-list"))
              ,@(map (lambda (post)
                       (post->sxml post #:post-uri (post-url post site)))
                     posts)))))

(define %hpc-haunt-theme
  ;; Theme for the rendering of the news pages.
  (theme #:name "Guix-HPC"
         #:layout (lambda (site title body)
                    (base-layout body #:title %web-site-title))
         #:post-template post->sxml
         #:collection-template page->sxml))

(define %local-test?
  ;; True when we're testing locally, as opposed to producing things to
  ;; install to gnu.org.
  (or (getenv "WEB_SITE_LOCAL")
      (member "serve" (command-line))))           ;'haunt serve' command

(when %local-test?
  ;; The URLs produced in these pages are only meant for local consumption.
  (format #t "~%Producing Web pages for local tests *only*!~%~%"))

(site #:title %web-site-title
      #:domain "//hpc.guixsd.org/"
      #:default-metadata
      '((author . "Guix-HPC Contributors")
        (email  . "guix-devel@gnu.org"))
      #:readers (list commonmark-reader)
      #:builders
      (cons* (blog #:theme %hpc-haunt-theme
                   #:prefix "blog")

             ;; Apparently the <link> tags of Atom entries must be absolute URLs,
             ;; hence this #:blog-prefix.
             (atom-feed #:file-name "blog/feed.xml"
                        #:blog-prefix "https://hpc.guixsd.org")

             (static-directory "static")

             (map (lambda (page)
                    (lambda (site posts)
                      page))
                  (static-pages))))
