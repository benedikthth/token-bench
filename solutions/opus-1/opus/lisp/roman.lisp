(defparameter *table*
  '((1000 . "M") (900 . "CM") (500 . "D") (400 . "CD")
    (100 . "C") (90 . "XC") (50 . "L") (40 . "XL")
    (10 . "X") (9 . "IX") (5 . "V") (4 . "IV") (1 . "I")))

(defun roman (n)
  (with-output-to-string (s)
    (dolist (pair *table*)
      (loop while (>= n (car pair))
            do (write-string (cdr pair) s)
               (decf n (car pair))))))

(loop for line = (read-line *standard-input* nil nil)
      while line
      do (let ((n (parse-integer (string-trim '(#\Space #\Tab #\Return) line)
                                 :junk-allowed t)))
           (when n
             (write-line (roman n)))))
