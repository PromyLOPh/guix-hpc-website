;;; This module is part of Guix-HPC and is licensed under the same terms,
;;; those of the GNU GPL version 3 or (at your option) any later version.
;;;
;;; Copyright © 2017 Inria

;; Run 'guix build -f guix.scm' to build the web site.

(use-modules (guix) (gnu)
             (guix modules)
             (guix git-download))

(define haunt
  (specification->package "haunt"))

(define guile-commonmark
  (specification->package "guile-commonmark"))

(define guile-syntax-highlight
  (specification->package "guile-syntax-highlight"))

(define source
  (local-file "." "guix-hpc-web"
              #:recursive? #t
              #:select? (git-predicate ".")))

(with-imported-modules (source-module-closure
                        '((guix build utils)))
  #~(begin
      (use-modules (guix build utils))

      (copy-recursively #$source ".")

      ;; For Haunt.
      (setenv "GUILE_LOAD_PATH"
              (string-append
               #+(file-append guile-commonmark
                              "/share/guile/site/2.2")
               ":"
               #+(file-append guile-syntax-highlight
                              "/share/guile/site/2.2")))

      ;; So we can read/write UTF-8 files.
      (setenv "GUIX_LOCPATH"
              #+(file-append (specification->package "glibc-utf8-locales")
                             "/lib/locale"))
      (setenv "LC_ALL" "en_US.utf8")

      (and (zero? (system* #+(file-append haunt "/bin/haunt")
                           "build"))
           (begin
             (mkdir-p #$output)
             (copy-recursively "site" #$output)))))
