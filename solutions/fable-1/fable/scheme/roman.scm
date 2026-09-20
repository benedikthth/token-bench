(use-modules (ice-9 rdelim))

(define table
  '((1000 . "M") (900 . "CM") (500 . "D") (400 . "CD")
    (100 . "C") (90 . "XC") (50 . "L") (40 . "XL")
    (10 . "X") (9 . "IX") (5 . "V") (4 . "IV") (1 . "I")))

(define (roman n)
  (let loop ((n n) (t table) (acc '()))
    (cond ((= n 0) (apply string-append (reverse acc)))
          ((>= n (caar t)) (loop (- n (caar t)) t (cons (cdar t) acc)))
          (else (loop n (cdr t) acc)))))

(define (main)
  (let ((line (read-line)))
    (if (not (eof-object? line))
        (let ((n (string->number (string-trim-both line))))
          (if n (begin (display (roman n)) (newline)))
          (main)))))

(main)
