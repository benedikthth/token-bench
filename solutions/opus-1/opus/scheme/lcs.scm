(use-modules (ice-9 rdelim))

(define (get-line)
  (let ((l (read-line)))
    (if (eof-object? l)
        ""
        (string-trim-right l (lambda (c) (or (char=? c #\return) (char-whitespace? c)))))))

(define a (get-line))
(define b (get-line))
(define n (string-length a))
(define m (string-length b))

(define (lcs)
  (let loop ((i 0) (prev (make-vector (+ m 1) 0)) (cur (make-vector (+ m 1) 0)))
    (if (= i n)
        (vector-ref prev m)
        (let ((ca (string-ref a i)))
          (vector-set! cur 0 0)
          (let inner ((j 1))
            (when (<= j m)
              (vector-set! cur j
                           (if (char=? ca (string-ref b (- j 1)))
                               (+ (vector-ref prev (- j 1)) 1)
                               (let ((x (vector-ref prev j))
                                     (y (vector-ref cur (- j 1))))
                                 (if (> x y) x y))))
              (inner (+ j 1))))
          (loop (+ i 1) cur prev)))))

(display (lcs))
(newline)
