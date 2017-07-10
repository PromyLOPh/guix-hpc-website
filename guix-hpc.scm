;;; This module is part of Guix-HPC and is licensed under the same terms,
;;; those of the GNU GPL version 3 or (at your option) any later version.
;;;
;;; Copyright © 2017 Inria

(define-module (guix-hpc)
  #:use-module (haunt page)
  #:use-module (haunt site)
  #:use-module (haunt html)
  #:use-module (haunt reader)
  #:use-module (haunt reader commonmark)
  #:use-module (srfi srfi-11)
  #:export (base-url
            image-url
            css-url
            post-url

            base-layout

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


(define* (base-layout body #:key (title "Guix-HPC"))
  `((doctype "html")
    (html (@ (lang "en"))
          (head
           (meta (@ (http-equiv "Content-Type")
                    (content "text/html; charset=utf-8")))
           (link (@ (rel "icon")
                    (type "image/x-icon")
                    (href ,(image-url "/favicon.png"))))
           (link (@ (rel "stylesheet")
                    (href ,(css-url "/main.css"))
                    (type "text/css")
                    (media "screen")))
           (title ,title))
	  (body
           (div (@ (id "header"))
                (div (@ (id "header-inner")
                        (class "width-control"))
                     (img (@ (class "logo")
                             (src ,(image-url "/logo.png"))))
                     (div (@ (class "baseline"))
                          "Reproducible software deployment for high-performance computing.")))
           (div (@ (id "menubar")
                   (class "width-control"))
                (ul
                 (li (a (@ (href ,(base-url "about.html")))
                        "About"))
                 (li (a (@ (href ,(base-url "/news/feed.xml")))
                        (img (@ (alt "Atom feed")
                                (src ,(image-url "/feed.png"))))))))

           (div (@ (id "content")
                   (class "width-control"))
                (div (@ (id "content-inner"))
                     (article ,body)))

           (div (@ (id "collaboration"))
                (div (@ (id "collaboration-inner")
                        (class "width-control"))
                     (p "Guix-HPC is a collaboration between:")
                     (div (@ (class "members"))
                          (ul
                           (li (img (@ (alt "MDC")
                                       (src ,(image-url "/mdc.png")))))
                           (li (img (@ (alt "Inria")
                                       (src ,(image-url "/inria.png")))))
                           (li (img (@ (alt "UMC Utrecht")
                                       (src ,(image-url "/umcutrecht.png")))))))))
           (div (@ (id "footer-box")
                   (class "width-control"))
                (p (a (@ (href "https://gitlab.inria.fr/guix-hpc/website"))
                      "Source of this site")))))))


(define %cwd
  (and=> (assq-ref (current-source-location) 'filename)
         dirname))

(define read-markdown
  (reader-proc commonmark-reader))

(define (read-markdown-page file)
  "Read the CommonMark page from FILE.  Return its final SXML
representation."
  (let-values (((meta body)
                (read-markdown (string-append %cwd "/" file))))
    (base-layout `(div (@ (class "post"))
                       (div (@ (class "post-body")) ,body))
                 #:title (string-append "Guix-HPC — "
                                        (assoc-ref meta 'title)))))

(define (about-page)
  (read-markdown-page "about.md"))

(define (static-pages)
  (list (make-page "about.html" (about-page) sxml->html)))
