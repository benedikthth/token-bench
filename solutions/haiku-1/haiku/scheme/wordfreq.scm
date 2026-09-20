(use-modules (ice-9 rdelim))

(define (is-letter? c)
  "Check if a character is an ASCII letter (A-Z or a-z)"
  (let ((code (char->integer c)))
    (or (and (>= code 65) (<= code 90))   ; A-Z
        (and (>= code 97) (<= code 122)))))  ; a-z

(define (read-all-lines)
  "Read all lines from standard input until EOF"
  (let loop ((lines '()))
    (let ((line (read-line)))
      (if (eof-object? line)
          (reverse lines)
          (loop (cons line lines))))))

(define (extract-words lines)
  "Extract all words (maximal runs of letters) from lines, converting to lowercase"
  (let loop ((lines lines) (words '()) (current '()))
    (if (null? lines)
        (if (null? current)
            (reverse words)
            (reverse (cons (list->string (reverse current)) words)))
        (let* ((line (car lines))
               (rest (cdr lines)))
          (let char-loop ((i 0) (words words) (current current))
            (if (>= i (string-length line))
                (loop rest words current)
                (let ((c (string-ref line i)))
                  (if (is-letter? c)
                      (char-loop (+ i 1) words (cons (char-downcase c) current))
                      (if (null? current)
                          (char-loop (+ i 1) words '())
                          (char-loop (+ i 1) (cons (list->string (reverse current)) words) '()))))))))))

(define (count-freq words)
  "Count word frequencies, returning association list (word . count)"
  (let loop ((words words) (freq '()))
    (if (null? words)
        freq
        (let* ((w (car words))
               (pair (assoc w freq)))
          (if pair
              (loop (cdr words) (map (lambda (p)
                                      (if (string=? (car p) w)
                                          (cons w (+ (cdr p) 1))
                                          p))
                                    freq))
              (loop (cdr words) (cons (cons w 1) freq)))))))

(define (compare a b)
  "Comparator for sorting: count descending, then word ascending"
  (let ((count-a (cdr a))
        (count-b (cdr b)))
    (if (= count-a count-b)
        (string<? (car a) (car b))
        (> count-a count-b))))

;; Main program
(let* ((lines (read-all-lines))
       (words (extract-words lines))
       (freq (count-freq words))
       (sorted (sort freq compare)))
  (for-each (lambda (pair)
              (display (car pair))
              (display " ")
              (display (cdr pair))
              (newline))
            sorted))
