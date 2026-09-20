(defparameter *values*
  '((1000 . "M") (900 . "CM") (500 . "D") (400 . "CD")
    (100 . "C") (90 . "XC") (50 . "L") (40 . "XL")
    (10 . "X") (9 . "IX") (5 . "V") (4 . "IV") (1 . "I")))

(defun to-roman (n)
  (with-output-to-string (s)
    (dolist (pair *values*)
      (let ((val (car pair)) (sym (cdr pair)))
        (loop while (>= n val)
              do (write-string sym s)
                 (decf n val))))))

(loop for line = (read-line *standard-input* nil nil)
      while line
      when (> (length (string-trim '(#\Space #\Tab #\Return) line)) 0)
      do (let ((n (parse-integer (string-trim '(#\Space #\Tab #\Return) line))))
           (format t "~A~%" (to-roman n))))
