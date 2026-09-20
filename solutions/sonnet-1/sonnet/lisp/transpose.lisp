(defun read-ints (stream)
  (let ((line (read-line stream nil nil)))
    (when line
      (with-input-from-string (s line)
        (loop for x = (read s nil nil)
              while x
              collect x)))))

(defun main ()
  (let* ((first-line (read-ints *standard-input*))
         (r (first first-line))
         (c (second first-line))
         (rows (loop repeat r collect (read-ints *standard-input*))))
    (dotimes (j c)
      (format t "~{~a~^ ~}~%"
              (loop for i from 0 below r
                    collect (nth j (nth i rows)))))))

(main)
