(use-modules (ice-9 rdelim))

(define (balanced? line)
  (let loop ((chars (string->list line)) (stack '()))
    (cond
      ((null? chars) (null? stack))
      (else
        (let ((c (car chars)) (rest (cdr chars)))
          (cond
            ((or (char=? c #\() (char=? c #\[) (char=? c #\{))
             (loop rest (cons c stack)))
            ((char=? c #\))
             (if (and (pair? stack) (char=? (car stack) #\())
                 (loop rest (cdr stack))
                 #f))
            ((char=? c #\])
             (if (and (pair? stack) (char=? (car stack) #\[))
                 (loop rest (cdr stack))
                 #f))
            ((char=? c #\})
             (if (and (pair? stack) (char=? (car stack) #\{))
                 (loop rest (cdr stack))
                 #f))
            ((or (char=? c #\return) (char-whitespace? c))
             (loop rest stack))
            (else #f)))))))

(define (main)
  (let loop ()
    (let ((line (read-line)))
      (if (not (eof-object? line))
          (begin
            (display (if (balanced? line) "yes" "no"))
            (newline)
            (loop))))))

(main)
