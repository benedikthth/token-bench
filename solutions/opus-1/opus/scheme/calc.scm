(use-modules (ice-9 rdelim))

(define (tokenize s)
  (let loop ((i 0) (acc '()))
    (if (>= i (string-length s))
        (reverse acc)
        (let ((c (string-ref s i)))
          (cond
           ((char-numeric? c)
            (let num ((j i) (v 0))
              (if (and (< j (string-length s)) (char-numeric? (string-ref s j)))
                  (num (+ j 1) (+ (* v 10) (- (char->integer (string-ref s j)) 48)))
                  (loop j (cons v acc)))))
           ((memv c '(#\+ #\- #\* #\/ #\( #\)))
            (loop (+ i 1) (cons c acc)))
           (else (loop (+ i 1) acc)))))))

(define toks '())

(define (peek) (if (null? toks) #f (car toks)))
(define (next!) (let ((t (car toks))) (set! toks (cdr toks)) t))

(define (parse-expr)
  (let loop ((v (parse-term)))
    (let ((t (peek)))
      (cond
       ((eqv? t #\+) (next!) (loop (+ v (parse-term))))
       ((eqv? t #\-) (next!) (loop (- v (parse-term))))
       (else v)))))

(define (parse-term)
  (let loop ((v (parse-factor)))
    (let ((t (peek)))
      (cond
       ((eqv? t #\*) (next!) (loop (* v (parse-factor))))
       ((eqv? t #\/) (next!) (loop (quotient v (parse-factor))))
       (else v)))))

(define (parse-factor)
  (let ((t (next!)))
    (if (eqv? t #\()
        (let ((v (parse-expr)))
          (next!)
          v)
        t)))

(let loop ()
  (let ((line (read-line)))
    (unless (eof-object? line)
      (set! toks (tokenize line))
      (unless (null? toks)
        (display (parse-expr))
        (newline))
      (loop))))
