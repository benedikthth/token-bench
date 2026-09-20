(defun read-lines ()
  (loop for line = (read-line *standard-input* nil nil)
        while line
        when (> (length (string-trim '(#\Return #\Space #\Tab) line)) 0)
        collect (string-trim '(#\Return #\Space #\Tab) line)))

(defun anagram-key (word)
  (sort (copy-seq word) #'char<))

(defun main ()
  (let ((words (read-lines))
        (table (make-hash-table :test 'equal)))
    (dolist (w words)
      (push w (gethash (anagram-key w) table)))
    (let (groups)
      (maphash (lambda (key value)
                 (declare (ignore key))
                 (push (sort value #'string<) groups))
               table)
      (setf groups (sort groups #'string< :key #'first))
      (dolist (g groups)
        (format t "~{~A~^ ~}~%" g)))))

(main)
