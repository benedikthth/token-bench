(use-modules (ice-9 rdelim))

(define table
  '((1000 . "M") (900 . "CM") (500 . "D") (400 . "CD")
    (100 . "C") (90 . "XC") (50 . "L") (40 . "XL")
    (10 . "X") (9 . "IX") (5 . "V") (4 . "IV") (1 . "I")))

(define (roman n)
  (let loop ((n n) (t table) (acc '()))
    (cond ((null? t) (apply string-append (reverse acc)))
          ((>= n (caar t)) (loop (- n (caar t)) t (cons (cdar t) acc)))
          (else (loop n (cdr t) acc)))))

(let loop ()
  (let ((line (read-line)))
    (unless (eof-object? line)
      (let ((n (string->number (string-trim-both line))))
        (when n
          (display (roman n))
          (newline)))
      (loop))))
