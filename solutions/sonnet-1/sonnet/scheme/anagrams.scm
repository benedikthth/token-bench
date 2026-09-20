(use-modules (ice-9 rdelim)
             (srfi srfi-1)
             (srfi srfi-13))

(define (read-lines)
  (let loop ((line (read-line)) (acc '()))
    (if (eof-object? line)
        (reverse acc)
        (loop (read-line) (cons line acc)))))

(define (sort-key word)
  (list->string (sort (string->list word) char<?)))

(define (group-words words)
  (let loop ((ws words) (groups '()))
    (if (null? ws)
        groups
        (let* ((w (car ws))
               (k (sort-key w))
               (entry (assoc k groups)))
          (if entry
              (begin
                (set-cdr! entry (cons w (cdr entry)))
                (loop (cdr ws) groups))
              (loop (cdr ws) (cons (cons k (list w)) groups)))))))

(define (main)
  (let* ((words (read-lines))
         (groups (group-words words))
         (sorted-groups (map (lambda (g) (sort (cdr g) string<?)) groups))
         (final-groups (sort sorted-groups
                              (lambda (a b) (string<? (car a) (car b))))))
    (for-each
     (lambda (g)
       (display (string-join g " "))
       (newline))
     final-groups)))

(main)
