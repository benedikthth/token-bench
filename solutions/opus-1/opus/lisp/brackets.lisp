(defun balanced-p (line)
  (let ((stack '()))
    (loop for c across line
          do (case c
               ((#\( #\[ #\{) (push c stack))
               (#\) (unless (eql (pop stack) #\() (return-from balanced-p nil)))
               (#\] (unless (eql (pop stack) #\[) (return-from balanced-p nil)))
               (#\} (unless (eql (pop stack) #\{) (return-from balanced-p nil)))
               (t nil)))
    (null stack)))

(loop for line = (read-line *standard-input* nil nil)
      while line
      do (write-line (if (balanced-p (string-right-trim '(#\Return) line))
                         "yes"
                         "no")))
