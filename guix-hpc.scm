;;; This module is part of Guix-HPC and is licensed under the same terms,
;;; those of the GNU GPL version 3 or (at your option) any later version.
;;;
;;; Copyright © 2017 Inria

(define-module (guix-hpc)
  #:use-module (haunt page)
  #:use-module (sxml simple)
  #:use-module (haunt reader)
  #:use-module (haunt reader commonmark)
  #:export (static-pages))

(define %cwd
  (and=> (assq-ref (current-source-location) 'filename)
         dirname))

(define read-markdown
  (reader-proc commonmark-reader))

(define (about-page)
  (read-markdown (string-append %cwd "/about.md")))

(define (static-pages)
  (list (make-page "about.html" (about-page) sxml->xml)))
