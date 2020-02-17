;;; This module extends GNU Guix and is licensed under the same terms, those
;;; of the GNU GPL version 3 or (at your option) any later version.
;;;
;;; Copyright © 2019, 2020 Inria

;; To build the document, run:
;;
;;   guix build -f build.scm
;;
;; The result will be a directory containing the activity report as PS and
;; PDF.

(use-modules (guix) (gnu)
             (srfi srfi-1)
             (ice-9 match))

(define %authoring-packages
  ;; Authoring tools needed.
  (append-map (lambda (package)
                (cons package
                      (match (package-transitive-propagated-inputs package)
                        (((labels packages) ...)
                         packages))))
              (map specification->package
                   '("haunt" "guile-commonmark" "skribilo"))))

(define (markdown->lout file)
  "Read Markdown from FILE, process it through Skribilo, and return a
directory containing Lout files."

  (define lout-files
    '("doc-style.lout"
      "cm-fonts.ld"
      "gentium-fonts.ld"
      "charis-fonts.ld"
      "inria-fonts.ld"
      "fira-fonts.ld"))

  (define logo
    (local-file "../image-sources/guixhpc-logo-transparent-white.svg"))

  (define lab-book
    (local-file "lab-book-cover.svg"))

  (define build
    (with-extensions %authoring-packages
      #~(begin
          (use-modules ((haunt post) #:select (read-metadata-headers))
                       (commonmark)
                       (skribilo output)
                       (skribilo engine)
                       (skribilo evaluator)
                       (skribilo package base)
                       (skribilo utils strings)
                       (srfi srfi-19)
                       (ice-9 match))

          (define-values (headers body)
            ;; Read the CommonMark document from FILE.
            (call-with-input-file #$file
              (lambda (port)
                (set-port-encoding! port "UTF-8")
                (let ((headers (read-metadata-headers port)))
                  (values headers
                          (commonmark->sxml port))))))

          (define (also-as-pdf? str)
            (string-prefix? "This document is also available" str))

          (define (sxml->skribilo sxml)
            ;; Convert SXML to Skribilo nodes.
            (match sxml
              (('p ('em (? also-as-pdf? str) . _))
               #t)                                ;discard
              (('p . body)
               (paragraph (map sxml->skribilo body)))
              (('h1 title)                        ;start on a new page
               (! "\n@NP\n1.2f @Font @Heading { $1 }\n//1.5fx\n"
                  (sxml->skribilo title)))
              (((or 'h2 'h3) title)
               (! "\n//1.2v\n@Heading { $1 }\n//0.9fx\n"
                  (sxml->skribilo title)))
              (('em . body)
               (emph (map sxml->skribilo body)))
              (('ul ('li . items) ...)
               (itemize (map (lambda (item-body)
                               (item (map sxml->skribilo item-body)))
                             items)))
              (('ol ('li . items) ...)
               (enumerate (map (lambda (item-body)
                                 (item (map sxml->skribilo item-body)))
                               items)))
              (('a ('@ ('href url)) . body)
               (append (map sxml->skribilo body)
                       (list (footnote
                              (ref #:url url #:text (it url))))))
              (('code . body)
               (tt (map sxml->skribilo body)))
              (((? string? strings) ...)
               (map sxml->skribilo strings))
              (('img . _)
               #t)                                ;dismiss images
              ((? string? str) str)))

          (define (back-cover)
            (! (format #f "@NP @NP @NP
//1rt
@Right 0.9 @Scale @IncludeGraphic { ~s }\n"
                       #+(svg->eps logo "guix-logo.eps"))))

          (define top
            ;; The Skribilo document.
            (document
             #:title (assoc-ref headers 'title)
             #:author (map (lambda (name)
                             (author #:name name))
                           (string-split (assoc-ref headers 'author)
                                         #\,))
             (map sxml->skribilo body)
             (back-cover)))

          (define %unicode-chars
            ;; XXX: The Lout engine in Skribilo 0.9.4 doesn't automatically
            ;; translate these Unicode characters, so here's a translation
            ;; table.
            `((#\  "~")                           ;no-break space
              (#\— "---")
              (#\– "--")
              (#\“ "``")
              (#\” "''")
              (#\‘ "`")
              (#\’ "'")
              (#\… "...")

              ;; Gross hack to work around Lout's lack of Unicode support.
              (#\ă "{ { { Times Base } @Font @Char \"breve\" } |0.5ro a }")
              (#\ș "{ { @Char \"cedilla\" } |0.5ro s }")))

          (define (make-front-cover doc engine)
            (format #t "{ @IncludeGraphic { ~s } }"
                    #+(svg->eps logo "guix-logo.eps"))
            (format #t "
//0.3c { FiraSans SemiBold 9p } @Font \"darkgrey\" @Color
{ Reproducible software deployment for high-performance computing. }

//0.6rt
@Center 0.3 @Scale { @IncludeGraphic { ~s } }\n"
                    #+(svg->eps lab-book "lab-book.eps"))
            (output (! "
//0.8rt { FiraSans Bold 24p } @Font { Activity Report 2018--2019 }
//1rt
{ FiraSans Base 9p } @Font \"darkgrey\" @Color @OneRow { $1 //1.3fx $2 }
@NP\n
@NP                                            # page 2 must be empty
//.2bt\n"
                       (date->string (assoc-ref headers 'date)
                                     "~e ~B ~Y")
                       (assoc-ref headers 'author))
                    engine))

          (define lout-engine
            ;; Lout engine with appropriate string filter.
            (let* ((lout   (find-engine 'lout))
                   (filter (engine-filter lout)))
              (copy-engine "lout" lout
                           #:filter
                           (compose (make-string-replace %unicode-chars)
                                    filter))))

          (engine-custom-set! lout-engine 'doc-cover-sheet-proc
                              make-front-cover)
          (engine-custom-set! lout-engine 'document-type 'doc)
          (engine-custom-set! lout-engine 'document-include
                              "@Include { doc-style.lout }\n")
	  (engine-custom-set! lout-engine 'initial-font
                              "GentiumPlus Base 11p")
	  (engine-custom-set! lout-engine 'initial-break
	                      (string-append "unbreakablefirst "
			                     "unbreakablelast "
                                             "marginkerning "
			                     "hyphen adjust 1.3fx"))
          (engine-custom-set! lout-engine 'includes
                              (string-append
                               (engine-custom lout-engine 'includes) "\n"
                               "@Database @FontDef { gentium-fonts }\n"
                               "@Database @FontDef { charis-fonts }\n"
                               "@Database @FontDef { inria-fonts }\n"
                               "@Database @FontDef { fira-fonts }\n"
                               "@Database @FontDef { cm-fonts }\n"))

          ;; Emit the Lout file.
          (parameterize ((*current-engine* lout-engine))
            (with-output-to-file "result.lout"
              (lambda ()
                (output (evaluate-document top lout-engine)
                        lout-engine))
              #:encoding "ISO-8859-1"))

          (mkdir #$output)
          (copy-file "result.lout"
                     (string-append #$output "/"
                                    #$(string-append
                                       (basename (local-file-name file)
                                                 ".md")
                                       ".lout")))

          ;; Copy all the Lout files that are needed to actually build the
          ;; document.
          (for-each (lambda (file base)
                      (copy-file file (string-append #$output "/" base)))
                    '#$(map (lambda (file)
                              (local-file file))
                            lout-files)
                    '#$lout-files))))

  (computed-file (string-append (basename (local-file-name file) ".md")
                                "-lout")
                 build))

(define (svg->eps svg name)
  (let ((inkscape (specification->package "inkscape")))
    (computed-file name
                   #~(begin
                       (unless (zero? (system*
                                       #+(file-append inkscape "/bin/inkscape")
                                       "--export-eps=t.eps" #$svg))
                         (error "inkscape failed!"))
                       (copy-file "t.eps" #$output)))))


(define ghostscript (specification->package "ghostscript"))
(define lout (specification->package "lout"))
(define font-gentium (specification->package "font-sil-gentium"))
(define font-charis (specification->package "font-sil-charis"))
(define font-inria (specification->package "font-blackfoundry-inria"))
(define font-fira-sans (specification->package "font-fira-sans"))
(define texlive-lm (specification->package "texlive-lm")) ;Latin Modern
(define coreutils (specification->package "coreutils"))
(define ttf2pt1 (specification->package "ttf2pt1"))

(define (truetype->type1 fonts)
  "Return a directory containing Type 1 .afm and .pfa files for FONTS."
  (define build
    (with-imported-modules '((guix build utils))
      #~(begin
          (use-modules (guix build utils)
                       (srfi srfi-1))

          (define ttf-files
            (append-map (lambda (font)
                          (find-files font "\\.ttf$"))
                        '#$fonts))

          (define directory
            (string-append #$output "/share/fonts/type1"))

          (mkdir-p directory)
          (for-each (lambda (ttf)
                      (let ((base (string-append directory "/"
                                                 (basename ttf ".ttf") )))
                        (invoke #$(file-append ttf2pt1 "/bin/ttf2pt1")
                                "-e" ttf base)))
                    ttf-files))))

  (computed-file "type1-fonts" build))

(define* (lout->pdf directory file #:key
                    (paper-size "A4")
                    (fonts (list font-gentium font-charis
                                 font-inria font-fira-sans)))
  "Build Lout source FILE, taken from DIRECTORY, and return the resulting
PDF."
  (define font-directory
    (truetype->type1 fonts))

  (define build
    (with-imported-modules '((guix build utils))
      #~(begin
          (use-modules (guix build utils))

          (define ps-file
            (string-append #$output "/"
                           #$(basename file ".lout") ".ps"))

          (define pdf-file
            (string-append #$output "/"
                           #$(basename file ".lout") ".pdf"))

          (mkdir #$output)
          (copy-recursively #$directory ".")
          (invoke #$(file-append lout "/bin/lout") "-a" "-r3"
                  "-I."
                  "-F" #$(file-append font-directory "/share/fonts/type1")
                  "-F" #$(file-append texlive-lm
                                      "/share/texmf-dist/fonts/afm/public/lm")
                  "-s" #$file "-o" ps-file)

          (setenv "PATH" (string-join '(#$ghostscript #$coreutils)
                                      "/bin:" 'suffix))
          (setenv "GS_FONTPATH"
                  (string-append #$font-directory "/share/fonts/type1:"
                                 #$texlive-lm
                                 "/share/texmf-dist/fonts/type1/public/lm"))
          (invoke #$(file-append ghostscript "/bin/ps2pdf")
                  "-dPDFSETTINGS=/prepress"
                  #$(string-append "-sPAPERSIZE="
                                   (string-downcase paper-size))
                  ps-file pdf-file))))

  (computed-file (basename file ".lout") build))


(lout->pdf (markdown->lout (local-file "../drafts/activity-report-2019.md"))
           "activity-report-2019.lout"
           #:paper-size "A5")
