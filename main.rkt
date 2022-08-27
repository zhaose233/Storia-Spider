#lang racket

(require "lib.rkt")
(require net/url)

(define (main name chapter n1 n2)

  ;; Check if path exists, if not, create it
  (let ((name-path (build-path name))
        (chapter-path (build-path name chapter)))
    (if (directory-exists? name-path) #t
        (make-directory name-path #o755))
    (if (directory-exists? chapter-path) #t
        (make-directory chapter-path #o755)))

  ;; download and decrypt all the pictures in this chapter
  (for ((i (map
            (lambda (n)
              (~r n #:min-width 4 #:pad-string "0"))
            (range n1 (+ n2 1)))))

    (define-values (s-p h-p in-pic)
      (http-sendrecv/url (string->url (string-append "https://storia.takeshobo.co.jp/_files/"
                                                     name
                                                     "/"
                                                     chapter
                                                     "/data/"
                                                     i
                                                     ".jpg"))))
    (define-values (s-j h-j in-json)
      (http-sendrecv/url (string->url (string-append "https://storia.takeshobo.co.jp/_files/"
                                                     name
                                                     "/"
                                                     chapter
                                                     "/data/"
                                                     i
                                                     ".ptimg.json"))))

    (displayln i)

    (send (generate-output-bitmap in-pic in-json) save-file (path->string (build-path name
                                                                                      chapter
                                                                                      (string-append i
                                                                                                     ".png"))) 'png)))
;; because some chapter does not start with 0001, you need to input the start number
(command-line
 #:args (name chapter n1 n2)
 (main name chapter (string->number n1) (string->number n2)))
                                                                        
    
