(defun read-integers-from-line ()
  "Read a line and parse it as a list of integers"
  (let ((line (read-line)))
    (with-input-from-string (stream line)
      (loop for x = (read stream nil nil)
            while x
            collect x))))

(let* ((r-c (read-integers-from-line))
       (r (first r-c)))
  (let ((matrix (loop repeat r
                      collect (read-integers-from-line))))
    (dolist (row (apply #'mapcar #'list matrix))
      (loop for (elem . rest) on row
            do (format t "~a" elem)
            if rest do (format t " "))
      (format t "~%"))))
