(use-modules (ice-9 rdelim))

(define values
  '((1000 . "M") (900 . "CM") (500 . "D") (400 . "CD")
    (100 . "C") (90 . "XC") (50 . "L") (40 . "XL")
    (10 . "X") (9 . "IX") (5 . "V") (4 . "IV") (1 . "I")))

(define (to-roman n)
  (let loop ((n n) (vs values) (acc ""))
    (cond
      ((= n 0) acc)
      ((>= n (caar vs))
       (loop (- n (caar vs)) vs (string-append acc (cdar vs))))
      (else (loop n (cdr vs) acc)))))

(let loop ()
  (let ((line (read-line)))
    (unless (eof-object? line)
      (unless (string=? (string-trim line) "")
        (display (to-roman (string->number (string-trim line))))
        (newline))
      (loop))))
