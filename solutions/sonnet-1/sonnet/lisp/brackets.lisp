(defun balanced-p (line)
  (let ((stack '()))
    (loop for ch across line do
      (case ch
        ((#\( #\[ #\{) (push ch stack))
        (#\)
         (unless (and stack (eql (pop stack) #\()) (return-from balanced-p nil)))
        (#\]
         (unless (and stack (eql (pop stack) #\[)) (return-from balanced-p nil)))
        (#\}
         (unless (and stack (eql (pop stack) #\{)) (return-from balanced-p nil)))
        (t nil)))
    (null stack)))

(loop for line = (read-line *standard-input* nil nil)
      while line
      do (format t "~a~%" (if (balanced-p line) "yes" "no")))
