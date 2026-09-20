;; Expression calculator: recursive-descent parser over a character list.

(use-modules (ice-9 rdelim))

(define (tokenize str)
  (let loop ((chars (string->list str)) (acc '()))
    (cond
     ((null? chars) (reverse acc))
     ((char-whitespace? (car chars)) (loop (cdr chars) acc))
     ((char-numeric? (car chars))
      (let num-loop ((cs chars) (n 0))
        (if (and (pair? cs) (char-numeric? (car cs)))
            (num-loop (cdr cs) (+ (* n 10) (- (char->integer (car cs)) 48)))
            (loop cs (cons n acc)))))
     (else (loop (cdr chars) (cons (car chars) acc))))))

;; Each parse function takes a token list and returns (value . remaining-tokens).

(define (parse-expr toks)
  (let loop ((res (parse-term toks)))
    (let ((val (car res)) (rest (cdr res)))
      (cond
       ((and (pair? rest) (eqv? (car rest) #\+))
        (let ((r (parse-term (cdr rest))))
          (loop (cons (+ val (car r)) (cdr r)))))
       ((and (pair? rest) (eqv? (car rest) #\-))
        (let ((r (parse-term (cdr rest))))
          (loop (cons (- val (car r)) (cdr r)))))
       (else res)))))

(define (parse-term toks)
  (let loop ((res (parse-factor toks)))
    (let ((val (car res)) (rest (cdr res)))
      (cond
       ((and (pair? rest) (eqv? (car rest) #\*))
        (let ((r (parse-factor (cdr rest))))
          (loop (cons (* val (car r)) (cdr r)))))
       ((and (pair? rest) (eqv? (car rest) #\/))
        (let ((r (parse-factor (cdr rest))))
          (loop (cons (quotient val (car r)) (cdr r)))))
       (else res)))))

(define (parse-factor toks)
  (cond
   ((null? toks) (cons 0 '()))
   ((number? (car toks)) (cons (car toks) (cdr toks)))
   ((eqv? (car toks) #\()
    (let ((r (parse-expr (cdr toks))))
      (if (and (pair? (cdr r)) (eqv? (cadr r) #\)))
          (cons (car r) (cddr r))
          r)))
   (else (cons 0 (cdr toks)))))

(define (evaluate str)
  (car (parse-expr (tokenize str))))

(define (blank? str)
  (let loop ((cs (string->list str)))
    (cond ((null? cs) #t)
          ((char-whitespace? (car cs)) (loop (cdr cs)))
          (else #f))))

(define (main)
  (let loop ()
    (let ((line (read-line)))
      (if (not (eof-object? line))
          (begin
            (if (not (blank? line))
                (begin
                  (display (evaluate line))
                  (newline)))
            (loop))))))

(main)
