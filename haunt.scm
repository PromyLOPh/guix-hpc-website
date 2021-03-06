;;; This module is part of Guix-HPC and is licensed under the same terms,
;;; those of the GNU GPL version 3 or (at your option) any later version.
;;;
;;; Copyright © 2017, 2019 Inria

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
             (ice-9 match)
             (srfi srfi-1)
             (srfi srfi-19)
             (srfi srfi-26)
             (guix-hpc))

(define %web-site-title
  "Guix-HPC — Reproducible software deployment for high-performance computing")

(define (post-sxml* post)
  "Add the 'full-width' class attribute to all 'img' tags of POST so that
they get properly displayed in blog articles."
  (let loop ((sxml (post-sxml post)))
    (match sxml
      (('img ('@ attributes ...) rest ...)
       `(img (@ (class "full-width") ,@attributes)
             ,@rest))
      (((? symbol? tag) ('@ attributes ...) rest ...)
       `(,tag (@ ,@attributes) ,@(map loop rest)))
      (((? symbol? tag) rest ...)
       `(,tag ,@(map loop rest)))
      ((lst ...)
       (map loop lst))
      (x x))))

(define (summarize-post post uri)
  (match (post-sxml* post)
    ((('p paragraph ...) _ ...)
     `((p ,@paragraph)
       (p (a (@ (href ,uri)) "Continue reading…"))))
    (body
     body)))

(define* (post->sxml post #:key post-uri summarize?)
  "Return the SXML for POST."
  (define post-body*
    (if summarize?
        (cut summarize-post <> post-uri)
        post-sxml*))

  `(div (@ (class "post"))
        (h1 (@ (class "title"))
            ,(if post-uri
                 `(a (@ (href ,post-uri))
                     ,(post-ref post 'title))
                 (post-ref post 'title)))
        (div (@ (class "post-about"))
             ,(post-ref post 'author)
             " — " ,(date->string (post-date post) "~B ~e, ~Y"))
        (hr)
        (div (@ (class "post-body"))
             ,(syntax-highlight (post-body* post)))))

(define (page->sxml site title posts prefix)
  "Return the SXML for the news page of SITE, containing POSTS."
  `((div (@ (class "header"))
         (div (@ (class "post-list"))
              ,@(map (lambda (post)
                       (post->sxml post #:post-uri (post-url post site)
                                   #:summarize? #t))
                     posts)))))

(define (post->page post site)
  (make-page (string-append (post-url post site) "/index.html")
             (render-post %hpc-haunt-theme site post)
             sxml->html))

(define %hpc-haunt-theme
  ;; Theme for the rendering of the news pages.
  (theme #:name "Guix-HPC"
         #:layout (lambda (site title body)
                    (base-layout body
                                 #:title (string-append "Guix-HPC — "
                                                        title)))
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
      #:domain "//hpc.guix.info"
      #:default-metadata
      '((author . "Guix-HPC Contributors")
        (email  . "guix-devel@gnu.org"))
      #:readers (list sxml-reader commonmark-reader)
      #:builders
      (cons* (lambda (site posts)
               ;; Pages for each post.
               (map (cut post->page <> site) posts))

             (lambda (site posts)
               ;; The main collection.
               (make-page
                "/blog/index.html"
                (render-collection %hpc-haunt-theme site
                                   "Reproducible software \
deployment for high-performance computing — Blog"         ;title
                                   (posts/reverse-chronological posts)
                                   "/blog")
                sxml->html))

             ;; Apparently the <link> tags of Atom entries must be absolute URLs,
             ;; hence this #:blog-prefix.
             (atom-feed #:file-name "blog/feed.xml"
                        #:blog-prefix "https://hpc.guix.info/blog")

             (static-directory "static")

             (static-pages)))
