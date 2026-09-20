(defun ascii-letter-p (c)
  (let ((code (char-code c)))
    (or (<= 65 code 90) (<= 97 code 122))))

(defun ascii-downcase (s)
  (map 'string
       (lambda (c)
         (let ((code (char-code c)))
           (if (<= 65 code 90) (code-char (+ code 32)) c)))
       s))

(defun main ()
  (let ((counts (make-hash-table :test 'equal))
        (buf (make-array 16 :element-type 'character :adjustable t :fill-pointer 0)))
    (flet ((flush ()
             (when (> (fill-pointer buf) 0)
               (incf (gethash (ascii-downcase (copy-seq buf)) counts 0))
               (setf (fill-pointer buf) 0))))
      (loop for c = (read-char *standard-input* nil nil)
            while c
            do (if (ascii-letter-p c)
                   (vector-push-extend c buf)
                   (flush)))
      (flush))
    (let ((entries '()))
      (maphash (lambda (k v) (push (cons k v) entries)) counts)
      (setf entries
            (sort entries
                  (lambda (a b)
                    (or (> (cdr a) (cdr b))
                        (and (= (cdr a) (cdr b))
                             (string< (car a) (car b)))))))
      (dolist (e entries)
        (write-string (car e))
        (write-char #\Space)
        (princ (cdr e))
        (terpri)))))

(main)
