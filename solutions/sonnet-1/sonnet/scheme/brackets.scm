(use-modules (ice-9 rdelim))

(define (matches? open close)
  (or (and (char=? open #\() (char=? close #\)))
      (and (char=? open #\[) (char=? close #\]))
      (and (char=? open #\{) (char=? close #\}))))

(define (balanced? line)
  (let loop ((chars (string->list line)) (stack '()))
    (cond
      ((null? chars) (null? stack))
      (else
       (let ((c (car chars)))
         (cond
           ((memv c '(#\( #\[ #\{))
            (loop (cdr chars) (cons c stack)))
           ((memv c '(#\) #\] #\}))
            (if (and (pair? stack) (matches? (car stack) c))
                (loop (cdr chars) (cdr stack))
                #f))
           (else (loop (cdr chars) stack))))))))

(let loop ()
  (let ((line (read-line)))
    (if (eof-object? line)
        #t
        (begin
          (display (if (balanced? line) "yes" "no"))
          (newline)
          (loop)))))
