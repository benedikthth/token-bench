(use-modules (ice-9 rdelim))

(define (int-to-roman n)
  (define pairs '((1000 . "M") (900 . "CM") (500 . "D") (400 . "CD")
                  (100 . "C") (90 . "XC") (50 . "L") (40 . "XL")
                  (10 . "X") (9 . "IX") (5 . "V") (4 . "IV") (1 . "I")))

  (let loop ((num n) (ps pairs) (result ""))
    (if (null? ps)
        result
        (let* ((value (caar ps))
               (numeral (cdar ps)))
          (if (>= num value)
              (loop (- num value) ps (string-append result numeral))
              (loop num (cdr ps) result))))))

(let loop ()
  (let ((line (read-line)))
    (if (not (eof-object? line))
        (begin
          (display (int-to-roman (string->number line)))
          (newline)
          (loop)))))
