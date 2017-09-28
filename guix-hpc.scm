;;; This module is part of Guix-HPC and is licensed under the same terms,
;;; those of the GNU GPL version 3 or (at your option) any later version.
;;;
;;; Copyright © 2017 Inria
;;; Copyright © 2017 Ludovic Courtès
;;; Copyright © 2015 David Thompson <davet@gnu.org>
;;; Copyright © 2016 Christopher Allan Webber <cwebber@dustycloud.org>

(define-module (guix-hpc)
  #:use-module (haunt post)
  #:use-module (haunt page)
  #:use-module (haunt site)
  #:use-module (haunt html)
  #:use-module (haunt utils)
  #:use-module (haunt reader)
  #:use-module (haunt reader commonmark)
  #:use-module (syntax-highlight)
  #:use-module (syntax-highlight scheme)
  #:use-module (syntax-highlight lexers)
  #:use-module (sxml simple)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-11)
  #:use-module (srfi srfi-19)
  #:use-module (srfi srfi-26)
  #:export (base-url
            image-url
            css-url
            post-url

            syntax-highlight
            base-layout

            static-pages
            atom-feed))

(define (base-url . location)
  (string-concatenate (cons "" location)))

(define (image-url location)
  (base-url "/static/images" location))

(define (css-url location)
  (base-url "/static/css" location))

(define (post-url post site)
  "Return the URL of POST, a Haunt blog post, for SITE."
  (let ((date (post-date post)))
    (base-url "/blog/"
              (number->string (date-year date))
              "/"
              (string-pad (number->string (date-month date))
                          2 #\0)

              ;; There's an implicit "/index.html" here.
              "/" (site-post-slug site post))))


;;;
;;; Syntax highlighting (stolen from Guix's web site.)
;;;

(define %default-special-prefixes
  '("define" "syntax"))

(define lex-scheme/guix
  ;; Specialized lexer for the Scheme we use in Guix.
  ;; TODO: Add #~, #$, etc.
  (make-scheme-lexer (cons* "with-imported-modules"
                            "gexp" "ungexp"
                            "ungexp-native" "ungexp-splicing"
                            "ungexp-native-splicing"
                            "mlet" "mlet*"
                            "match"
                            %default-special-symbols)
                     %default-special-prefixes))

(define (syntax-highlight sxml)
  "Recurse over SXML and syntax-highlight code snippets."
  (match sxml
    (('code ('@ ('class "language-scheme")) code-snippet)
     `(code ,(highlights->sxml
              (highlight lex-scheme/guix code-snippet))))
    ((tag ('@ attributes ...) body ...)
     `(,tag (@ ,@attributes) ,@(map syntax-highlight body)))
    ((tag body ...)
     `(,tag ,@(map syntax-highlight body)))
    ((? string? str)
     str)))

(define* (base-layout body #:key (title "Guix-HPC") (meta '()))
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
           (div (@ (id "header")
                   ,@(if (assoc-ref meta 'frontpage)
                         '((class "frontpage"))
                         '()))
                (div (@ (id "header-inner")
                        (class "width-control"))
                     (a (@ (href ,(base-url "/")))
                        (img (@ (class "logo")
                                (src ,(image-url (if (assoc-ref meta 'frontpage)
                                                     "/logo.png"
                                                     "/logo-small.png"))))))
                     (div (@ (class "baseline"))
                          "Reproducible software deployment for high-performance computing.")))
           (div (@ (id "menubar")
                   (class "width-control"))
                (ul
                 (li (a (@ (href ,(base-url "/about")))
                        "About"))
                 (li (a (@ (href ,(base-url "/browse")))
                        "Browse"))
                 (li (a (@ (href ,(base-url "/blog")))
                        "Blog"))
                 (li (a (@ (href ,(base-url "/blog/feed.xml")))
                        (img (@ (alt "Atom feed")
                                (src ,(image-url "/feed.png"))))))))

           (div (@ (id "content")
                   (class "width-control"))
                (div (@ (id "content-inner"))
                     (article ,body)))

           (div (@ (id "collaboration"))
                (div (@ (id "collaboration-inner")
                        (class "width-control"))
                     (div (@ (class "members"))
                          (ul
                           (li (img (@ (alt "MDC")
                                       (src ,(image-url "/mdc.png")))))
                           (li (img (@ (alt "Inria")
                                       (src ,(image-url "/inria.png")))))
                           (li (img (@ (alt "UBC")
                                       (src ,(image-url "/ubc.png")))))))))
           (div (@ (id "footer-box")
                   (class "width-control"))
                (p (a (@ (href "https://gitlab.inria.fr/guix-hpc/website"))
                      "Source of this site")))))))


;;;
;;; Static pages.
;;;

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
                       (div (@ (class "post-body"))
                            ,(syntax-highlight body)))
                 #:title (string-append "Guix-HPC — "
                                        (assoc-ref meta 'title))
                 #:meta meta)))

(define (static-pages)
  (define (markdown-page html md)
    (make-page html (read-markdown-page md)
               sxml->html))

  (list (markdown-page "about/index.html" "about.md")
        (markdown-page "index.html" "getting-started.md")))


;;;
;;; Atom feed (stolen from Haunt and adjusted).
;;;

;;; We cannot use Haunt's 'atom-feed' because of the non-default post URLs
;;; that we use.  Thus the code below is mostly duplicated from (haunt
;;; builder atom), with the exception of the URLs.

(define (sxml->xml* sxml port)
  "Write SXML to PORT, preceded by an <?xml> tag."
  (display "<?xml version=\"1.0\" encoding=\"utf-8\"?>" port)
  (sxml->xml sxml port))

(define (date->string* date)
  "Convert date to ISO-8601 formatted string."
  (date->string date "~4"))

(define* (post->atom-entry site post #:key (blog-prefix ""))
  "Convert POST into an Atom <entry> XML node."
  `(entry
    (title ,(post-ref post 'title))
    (author
     (name ,(post-ref post 'author))
     ,(let ((email (post-ref post 'email)))
        (if email `(email ,email) '())))
    (updated ,(date->string* (post-date post)))
    (link (@ (href ,(post-url post site))
             (rel "alternate")))
    (summary (@ (type "html"))
             ,(sxml->html-string (post-sxml post)))))

(define* (atom-feed #:key
                    (file-name "feed.xml")
                    (subtitle "Recent Posts")
                    (filter posts/reverse-chronological)
                    (max-entries 20)
                    (blog-prefix ""))
  "Return a builder procedure that renders a list of posts as an Atom
feed.  All arguments are optional:

FILE-NAME: The page file name
SUBTITLE: The feed subtitle
FILTER: The procedure called to manipulate the posts list before rendering
MAX-ENTRIES: The maximum number of posts to render in the feed"
  (lambda (site posts)
    (make-page file-name
               `(feed (@ (xmlns "http://www.w3.org/2005/Atom"))
                      (title ,(site-title site))
                      (subtitle ,subtitle)
                      (updated ,(date->string* (current-date)))
                      (link (@ (href ,(string-append (site-domain site)
                                                     "/" file-name))
                               (rel "self")))
                      (link (@ (href ,(site-domain site))))
                      ,@(map (cut post->atom-entry site <>
                                  #:blog-prefix blog-prefix)
                             (take-up-to max-entries (filter posts))))
               sxml->xml*)))
