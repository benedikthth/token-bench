(defun sieve-of-eratosthenes (n)
  "Return a list of all primes <= n using the Sieve of Eratosthenes"
  (if (< n 2)
      '()
      (let ((sieve (make-array (+ n 1) :initial-element t)))
        (setf (aref sieve 0) nil)
        (setf (aref sieve 1) nil)
        (loop for i from 2 to (isqrt n) do
          (when (aref sieve i)
            (loop for j from (* i i) to n by i do
              (setf (aref sieve j) nil))))
        (loop for i from 2 to n
              when (aref sieve i)
              collect i))))

(let ((n (read)))
  (let ((primes (sieve-of-eratosthenes n)))
    (format t "~{~a~^ ~}~%" primes)))
