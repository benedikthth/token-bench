(defparameter *numerals*
  '((1000 . "M") (900 . "CM") (500 . "D") (400 . "CD")
    (100 . "C") (90 . "XC") (50 . "L") (40 . "XL")
    (10 . "X") (9 . "IX") (5 . "V") (4 . "IV") (1 . "I")))

(defun to-roman (n)
  (with-output-to-string (out)
    (dolist (pair *numerals*)
      (loop while (>= n (car pair))
            do (write-string (cdr pair) out)
               (decf n (car pair))))))

(defun main ()
  (loop for line = (read-line *standard-input* nil nil)
        while line
        do (let ((trimmed (string-trim '(#\Space #\Tab #\Return #\Newline) line)))
             (when (plusp (length trimmed))
               (let ((n (parse-integer trimmed :junk-allowed t)))
                 (when n
                   (write-line (to-roman n))))))))

(main)
