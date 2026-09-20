(use-modules (ice-9 rdelim))

(define (lcs-length str1 str2)
  (let* ((m (string-length str1))
         (n (string-length str2))
         (dp (make-vector (+ m 1))))

    ; Initialize the dp table with vectors for each row
    (do ((i 0 (+ i 1)))
        ((> i m))
      (vector-set! dp i (make-vector (+ n 1) 0)))

    ; Fill the DP table
    (do ((i 1 (+ i 1)))
        ((> i m))
      (do ((j 1 (+ j 1)))
          ((> j n))
        (if (char=? (string-ref str1 (- i 1)) (string-ref str2 (- j 1)))
            ; Characters match: add 1 to diagonal
            (vector-set! (vector-ref dp i) j
                        (+ (vector-ref (vector-ref dp (- i 1)) (- j 1)) 1))
            ; Characters don't match: take maximum of left and top
            (vector-set! (vector-ref dp i) j
                        (max (vector-ref (vector-ref dp (- i 1)) j)
                             (vector-ref (vector-ref dp i) (- j 1)))))))

    ; Return the bottom-right cell
    (vector-ref (vector-ref dp m) n)))

; Read two lines and output the LCS length
(let ((line1 (read-line))
      (line2 (read-line)))
  (display (lcs-length line1 line2))
  (newline))
