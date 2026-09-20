(use-modules (ice-9 rdelim))

(define (sort-key w)
  (list->string (sort (string->list w) char<?)))

(define (read-words)
  (let loop ((acc '()))
    (let ((line (read-line)))
      (if (eof-object? line)
          (reverse acc)
          (let ((w (string-trim-both line)))
            (loop (if (string-null? w) acc (cons w acc))))))))

(define (main)
  (let ((table (make-hash-table)))
    (for-each
     (lambda (w)
       (let ((k (sort-key w)))
         (hash-set! table k (cons w (hash-ref table k '())))))
     (read-words))
    (let* ((groups (hash-map->list (lambda (k v) (sort v string<?)) table))
           (sorted (sort groups (lambda (a b) (string<? (car a) (car b))))))
      (for-each
       (lambda (g)
         (display (string-join g " "))
         (newline))
       sorted))))

(main)
