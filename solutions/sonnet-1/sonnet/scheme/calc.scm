;; Expression calculator: reads one arithmetic expression per line,
;; prints its integer value per line, honoring standard precedence.

(use-modules (ice-9 rdelim))

(define (tokenize line)
  (let ((len (string-length line)))
    (let loop ((i 0) (tokens '()))
      (cond
        ((>= i len) (reverse tokens))
        ((char-whitespace? (string-ref line i)) (loop (+ i 1) tokens))
        ((char-numeric? (string-ref line i))
         (let loop2 ((j i))
           (if (and (< j len) (char-numeric? (string-ref line j)))
               (loop2 (+ j 1))
               (loop j (cons (string->number (substring line i j)) tokens)))))
        (else
         (loop (+ i 1) (cons (string (string-ref line i)) tokens)))))))

;; Each parse-* function takes a token list and returns (value . remaining-tokens)

(define (parse-factor tokens)
  (let ((tok (car tokens)))
    (if (equal? tok "(")
        (let* ((result (parse-expr (cdr tokens)))
               (value (car result))
               (rest (cdr result)))
          ;; rest's first token must be ")"
          (cons value (cdr rest)))
        (cons tok (cdr tokens)))))

(define (parse-term tokens)
  (let loop ((result (parse-factor tokens)))
    (let ((value (car result))
          (rest (cdr result)))
      (if (and (pair? rest) (or (equal? (car rest) "*") (equal? (car rest) "/")))
          (let* ((op (car rest))
                 (next (parse-factor (cdr rest)))
                 (nval (car next))
                 (nrest (cdr next)))
            (loop (cons (if (equal? op "*")
                            (* value nval)
                            (quotient value nval))
                        nrest)))
          result))))

(define (parse-expr tokens)
  (let loop ((result (parse-term tokens)))
    (let ((value (car result))
          (rest (cdr result)))
      (if (and (pair? rest) (or (equal? (car rest) "+") (equal? (car rest) "-")))
          (let* ((op (car rest))
                 (next (parse-term (cdr rest)))
                 (nval (car next))
                 (nrest (cdr next)))
            (loop (cons (if (equal? op "+")
                            (+ value nval)
                            (- value nval))
                        nrest)))
          result))))

(define (eval-line line)
  (car (parse-expr (tokenize line))))

(let loop ()
  (let ((line (read-line)))
    (if (eof-object? line)
        #t
        (begin
          (display (eval-line line))
          (newline)
          (loop)))))
