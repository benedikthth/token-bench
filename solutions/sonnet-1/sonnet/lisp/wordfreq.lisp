(defun read-all-input ()
  (with-output-to-string (out)
    (loop for line = (read-line *standard-input* nil nil)
          while line
          do (write-line line out))))

(defun extract-words (text)
  (let ((words '())
        (start nil)
        (len (length text)))
    (loop for i from 0 below len
          for ch = (char text i)
          do (if (alpha-char-p ch)
                 (unless start (setf start i))
                 (when start
                   (push (string-downcase (subseq text start i)) words)
                   (setf start nil))))
    (when start
      (push (string-downcase (subseq text start len)) words))
    (nreverse words)))

(defun main ()
  (let* ((text (read-all-input))
         (words (extract-words text))
         (table (make-hash-table :test 'equal)))
    (dolist (w words)
      (incf (gethash w table 0)))
    (let ((entries '()))
      (maphash (lambda (k v) (push (cons k v) entries)) table)
      (setf entries (sort entries (lambda (a b)
                                     (if (= (cdr a) (cdr b))
                                         (string< (car a) (car b))
                                         (> (cdr a) (cdr b))))))
      (dolist (e entries)
        (format t "~a ~a~%" (car e) (cdr e))))))

(main)
