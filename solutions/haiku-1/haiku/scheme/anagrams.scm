(use-modules (ice-9 rdelim))

(define (sort-chars str)
  "Sort the characters in a string"
  (list->string (sort (string->list str) char<?)))

(define (read-all-words)
  "Read all lines from stdin until EOF"
  (let loop ((words '()))
    (let ((line (read-line)))
      (if (eof-object? line)
          (reverse words)
          (loop (cons line words))))))

(define (add-word-to-groups word groups)
  "Add a word to the appropriate group based on anagram key"
  (let ((key (sort-chars word)))
    (define (loop groups)
      (cond
        ((null? groups)
         (list (cons key (list word))))
        ((string=? (caar groups) key)
         (cons (cons key (cons word (cdar groups))) (cdr groups)))
        (else
         (cons (car groups) (loop (cdr groups))))))
    (loop groups)))

(define (main)
  (let* ((words (read-all-words))
         ; Build groups table where each entry is (key . words)
         (groups-table (let loop ((words words) (groups '()))
                         (if (null? words)
                             groups
                             (loop (cdr words) (add-word-to-groups (car words) groups)))))
         ; Sort words within each group
         (sorted-groups (map (lambda (entry)
                               (sort (cdr entry) string<?))
                             groups-table))
         ; Sort groups by their first word
         (final-groups (sort sorted-groups
                             (lambda (g1 g2) (string<? (car g1) (car g2))))))
    ; Output each group
    (for-each (lambda (group)
                (display (string-join group " "))
                (newline))
              final-groups)))

(main)
