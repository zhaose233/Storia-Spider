#lang racket

(require racket/draw)
(require json)

;; stucture saving coordinates to generate picture from the source
(struct operation-coordinates (from size to))

;; input-port? input-port? -> bitmap?
(define (generate-output-bitmap in-pic in-json)
  (let* ((j (read-json in-json))
         (in-bm (read-bitmap in-pic))
         (out-bm (make-bitmap (hash-ref (car (hash-ref j 'views)) 'width)
                              (hash-ref (car (hash-ref j 'views)) 'height)))
         (operation-l (map get-coordinate (hash-ref (car (hash-ref j 'views)) 'coords))))
    (map (lambda (op)
           (copy-paste-pixels in-bm op out-bm))
         operation-l)
    out-bm))

;; move the pixels acroding to the coordinates
;; bitmap? operation-coordinates? bitmap? -> void?
(define (copy-paste-pixels in-bm op out-bm)
  (let* ((bts (make-bytes (*
                           4
                           (car (operation-coordinates-size op))
                           (cdr (operation-coordinates-size op))))))
    (send in-bm get-argb-pixels
          (car (operation-coordinates-from op))
          (cdr (operation-coordinates-from op))
          (car (operation-coordinates-size op))
          (cdr (operation-coordinates-size op))
          bts)
    (send out-bm set-argb-pixels
          (car (operation-coordinates-to op))
          (cdr (operation-coordinates-to op))
          (car (operation-coordinates-size op))
          (cdr (operation-coordinates-size op))
          bts)))

;; get information from the string input
;; string? -> operation-coordinates?
(define (get-coordinate str)
  (let* ((str-replaced (string-replace str "i:" ""))
         (splited (string-split str-replaced ">"))
         (first-coordinate-l (string-split (car splited) "+"))
         (from-coordinate-l (map string->number (string-split (car first-coordinate-l) ",")))
         (size-l (map string->number (string-split (cadr first-coordinate-l) ",")))
         (to-coordinate-l (map string->number (string-split (cadr splited) ","))))
    (operation-coordinates
     (cons (car from-coordinate-l) (cadr from-coordinate-l))
     (cons (car size-l) (cadr size-l))
     (cons (car to-coordinate-l) (cadr to-coordinate-l)))))

(provide (all-defined-out))
