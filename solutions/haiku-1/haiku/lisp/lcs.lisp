(defun lcs-length (str1 str2)
  (let* ((m (length str1))
         (n (length str2))
         (dp (make-array (list (+ m 1) (+ n 1)) :initial-element 0)))
    (dotimes (i (+ m 1))
      (dotimes (j (+ n 1))
        (cond
          ((or (= i 0) (= j 0)) nil)
          ((char= (char str1 (- i 1)) (char str2 (- j 1)))
           (setf (aref dp i j) (+ (aref dp (- i 1) (- j 1)) 1)))
          (t
           (setf (aref dp i j) (max (aref dp (- i 1) j) (aref dp i (- j 1))))))))
    (aref dp m n)))

(let ((str1 (read-line))
      (str2 (read-line)))
  (format t "~d~%" (lcs-length str1 str2)))
