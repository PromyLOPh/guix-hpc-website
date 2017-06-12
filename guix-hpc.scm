;;; This module is part of Guix-HPC and is licensed under the same terms,
;;; those of the GNU GPL version 3 or (at your option) any later version.
;;;
;;; Copyright © 2017 Inria

(define-module (guix-hpc)
  #:use-module (haunt page)
  #:use-module (haunt site)
  #:use-module (sxml simple)
  #:use-module (haunt reader)
  #:use-module (haunt reader commonmark)
  #:export (base-url
            image-url
            css-url
            post-url

            static-pages))

(define (base-url . location)
  (string-concatenate (cons "" location)))

(define (image-url location)
  (base-url "static/images" location))

(define (css-url location)
  (base-url "static/css" location))

(define (post-url post site)
  "Return the URL of POST, a Haunt blog post, for SITE."
  (base-url (site-post-slug site post) ".html"))


(define %cwd
  (and=> (assq-ref (current-source-location) 'filename)
         dirname))

(define read-markdown
  (reader-proc commonmark-reader))

(define (about-page)
  (read-markdown (string-append %cwd "/about.md")))

(define (static-pages)
  (list (make-page "about.html" (about-page) sxml->xml)))
