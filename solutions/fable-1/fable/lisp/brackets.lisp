(defun balanced-p (line)
  (let ((stack '()))
    (loop for c across line do
      (case c
        ((#\( #\[ #\{) (push c stack))
        (#\) (if (and stack (char= (car stack) #\()) (pop stack) (return-from balanced-p nil)))
        (#\] (if (and stack (char= (car stack) #\[)) (pop stack) (return-from balanced-p nil)))
        (#\} (if (and stack (char= (car stack) #\{)) (pop stack) (return-from balanced-p nil)))
        ((#\Return #\Space #\Tab) nil)
        (t (return-from balanced-p nil))))
    (null stack)))

(defun main ()
  (loop for line = (read-line *standard-input* nil nil)
        while line
        do (write-line (if (balanced-p line) "yes" "no"))))

(main)
