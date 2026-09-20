(define n (let ((x (read))) (if (eof-object? x) 0 x)))

(define sieve (make-vector (+ n 1) #t))

(let loop ((i 2))
  (when (<= (* i i) n)
    (when (vector-ref sieve i)
      (let mark ((j (* i i)))
        (when (<= j n)
          (vector-set! sieve j #f)
          (mark (+ j i)))))
    (loop (+ i 1))))

(let loop ((i 2) (first #t))
  (when (<= i n)
    (if (vector-ref sieve i)
        (begin
          (if (not first) (display " "))
          (display i)
          (loop (+ i 1) #f))
        (loop (+ i 1) first))))
(newline)
