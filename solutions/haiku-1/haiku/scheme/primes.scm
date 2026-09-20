(define (sieve n)
  (if (< n 2)
      '()
      (let ((is-prime (make-vector (+ n 1) #t)))
        (vector-set! is-prime 0 #f)
        (vector-set! is-prime 1 #f)

        ; Mark non-primes using Sieve of Eratosthenes
        (let mark-loop ((i 2))
          (if (<= i n)
            (begin
              (if (vector-ref is-prime i)
                (let mark-multiples ((j (* i i)))
                  (if (<= j n)
                    (begin
                      (vector-set! is-prime j #f)
                      (mark-multiples (+ j i))))))
              (mark-loop (+ i 1)))))

        ; Collect all primes
        (let collect-loop ((i 2) (result '()))
          (if (> i n)
            (reverse result)
            (if (vector-ref is-prime i)
              (collect-loop (+ i 1) (cons i result))
              (collect-loop (+ i 1) result)))))))

(define (main)
  (let ((n (read)))
    (let ((primes (sieve n)))
      (if (null? primes)
        (newline)
        (begin
          (display (car primes))
          (for-each (lambda (p)
                      (display " ")
                      (display p))
                    (cdr primes))
          (newline))))))

(main)
