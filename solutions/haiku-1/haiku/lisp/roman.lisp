(defun int-to-roman (n)
  "Convert an integer (1-3999) to its Roman numeral representation."
  (let ((pairs '((1000 . "M") (900 . "CM") (500 . "D") (400 . "CD")
                 (100 . "C") (90 . "XC") (50 . "L") (40 . "XL")
                 (10 . "X") (9 . "IX") (5 . "V") (4 . "IV") (1 . "I")))
        (result ""))
    (dolist (pair pairs result)
      (loop while (>= n (car pair))
            do (setf result (concatenate 'string result (cdr pair)))
               (setf n (- n (car pair)))))))

(loop for line = (read-line nil nil)
      while line
      do (when (> (length line) 0)
           (let ((n (parse-integer line)))
             (format t "~a~%" (int-to-roman n)))))