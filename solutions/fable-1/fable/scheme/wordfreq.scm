(use-modules (ice-9 rdelim))

(define (ascii-letter? c)
  (let ((n (char->integer c)))
    (or (and (>= n 65) (<= n 90))
        (and (>= n 97) (<= n 122)))))

(define (ascii-downcase c)
  (let ((n (char->integer c)))
    (if (and (>= n 65) (<= n 90))
        (integer->char (+ n 32))
        c)))

(define table (make-hash-table))

(define (add-word! chars)
  (let ((w (list->string (reverse chars))))
    (hash-set! table w (+ 1 (hash-ref table w 0)))))

(define (process-text)
  (let loop ((c (read-char)) (cur '()))
    (cond
      ((eof-object? c)
       (if (not (null? cur)) (add-word! cur)))
      ((ascii-letter? c)
       (loop (read-char) (cons (ascii-downcase c) cur)))
      (else
       (if (not (null? cur)) (add-word! cur))
       (loop (read-char) '())))))

(define (entry<? a b)
  (cond
    ((> (cdr a) (cdr b)) #t)
    ((< (cdr a) (cdr b)) #f)
    (else (string<? (car a) (car b)))))

(process-text)

(let ((entries (sort (hash-map->list cons table) entry<?)))
  (for-each
    (lambda (e)
      (display (car e))
      (display " ")
      (display (cdr e))
      (newline))
    entries))
