(let* ((n (or (read *standard-input* nil nil) 0))
       (sieve (make-array (1+ (max n 1)) :element-type 'bit :initial-element 1))
       (first t))
  (loop for i from 2 while (<= (* i i) n)
        when (= (sbit sieve i) 1)
          do (loop for j from (* i i) to n by i
                   do (setf (sbit sieve j) 0)))
  (let ((out (make-string-output-stream)))
    (loop for i from 2 to n
          when (= (sbit sieve i) 1)
            do (if first
                   (setf first nil)
                   (write-char #\Space out))
               (princ i out))
    (write-string (get-output-stream-string out))
    (terpri)))
