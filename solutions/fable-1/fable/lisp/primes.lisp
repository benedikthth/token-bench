(defun main ()
  (let* ((n (or (read *standard-input* nil nil) 0))
         (n (max 0 n))
         (sieve (make-array (1+ n) :element-type 'bit :initial-element 1))
         (first t))
    (when (>= n 0) (setf (sbit sieve 0) 0))
    (when (>= n 1) (setf (sbit sieve 1) 0))
    (loop for i from 2
          while (<= (* i i) n)
          do (when (= (sbit sieve i) 1)
               (loop for j from (* i i) to n by i
                     do (setf (sbit sieve j) 0))))
    (loop for i from 2 to n
          do (when (= (sbit sieve i) 1)
               (if first
                   (setf first nil)
                   (write-char #\Space))
               (format t "~D" i)))
    (terpri)))

(main)
