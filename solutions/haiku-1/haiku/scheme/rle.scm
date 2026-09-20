(use-modules (ice-9 rdelim))

(define (encode str)
  (let loop ((chars (string->list str))
             (result ""))
    (if (null? chars)
        result
        (let ((char (car chars)))
          (let count-loop ((remaining (cdr chars))
                          (count 1))
            (if (or (null? remaining)
                    (not (char=? char (car remaining))))
                (loop remaining
                      (string-append result
                                    (string char)
                                    (number->string count)))
                (count-loop (cdr remaining) (+ count 1))))))))

(let ((line (read-line)))
  (display (encode (if (eof-object? line) "" line)))
  (newline))
