(defun main ()
  (let ((n (read)))
    (if (< n 2)
        (format t "~%")
        (let ((sieve (make-array (1+ n) :initial-element t))
              (first t))
          (setf (aref sieve 0) nil)
          (setf (aref sieve 1) nil)
          (loop for i from 2 to n do
            (when (aref sieve i)
              (loop for j from (* i i) to n by i do
                (setf (aref sieve j) nil))))
          (loop for i from 2 to n do
            (when (aref sieve i)
              (if first
                  (setf first nil)
                  (write-char #\Space))
              (format t "~d" i)))
          (format t "~%")))))

(main)
