(define (ascii-letter? c)
  (or (and (char>=? c #\a) (char<=? c #\z))
      (and (char>=? c #\A) (char<=? c #\Z))))

(define (read-all-input)
  (let loop ((chars '()))
    (let ((c (read-char)))
      (if (eof-object? c)
          (list->string (reverse chars))
          (loop (cons c chars))))))

(define (extract-words str)
  (let ((len (string-length str)))
    (let loop ((i 0) (start #f) (words '()))
      (cond
        ((= i len)
         (reverse (if start (cons (string-downcase (substring str start i)) words) words)))
        ((ascii-letter? (string-ref str i))
         (loop (+ i 1) (or start i) words))
        (else
         (loop (+ i 1) #f (if start (cons (string-downcase (substring str start i)) words) words)))))))

(define (count-words words)
  (let ((table (make-hash-table)))
    (for-each
     (lambda (w)
       (hash-set! table w (+ 1 (or (hash-ref table w) 0))))
     words)
    (hash-map->list cons table)))

(define (word-less? a b)
  (cond ((> (cdr a) (cdr b)) #t)
        ((< (cdr a) (cdr b)) #f)
        (else (string<? (car a) (car b)))))

(define (main)
  (let* ((text (read-all-input))
         (words (extract-words text))
         (counts (count-words words))
         (sorted (sort counts word-less?)))
    (for-each
     (lambda (pair)
       (display (car pair))
       (display " ")
       (display (cdr pair))
       (newline))
     sorted)))

(main)
