(define (ascii-letter? c)
  (or (and (char>=? c #\a) (char<=? c #\z))
      (and (char>=? c #\A) (char<=? c #\Z))))

(define counts (make-hash-table))

(define (add-word! chars)
  (let ((w (list->string (reverse chars))))
    (hash-set! counts w (+ 1 (hash-ref counts w 0)))))

(let loop ((c (read-char)) (acc '()))
  (cond ((eof-object? c)
         (if (pair? acc) (add-word! acc)))
        ((ascii-letter? c)
         (loop (read-char) (cons (char-downcase c) acc)))
        (else
         (if (pair? acc) (add-word! acc))
         (loop (read-char) '()))))

(define entries (hash-map->list cons counts))

(define sorted
  (sort entries
        (lambda (a b)
          (or (> (cdr a) (cdr b))
              (and (= (cdr a) (cdr b))
                   (string<? (car a) (car b)))))))

(for-each (lambda (e)
            (display (car e))
            (display " ")
            (display (cdr e))
            (newline))
          sorted)
