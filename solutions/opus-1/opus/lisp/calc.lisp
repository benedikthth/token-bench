(defvar *s* "")
(defvar *p* 0)

(defun skip-ws ()
  (loop while (and (< *p* (length *s*))
                   (member (char *s* *p*) '(#\Space #\Tab #\Return)))
        do (incf *p*)))

(defun peek ()
  (skip-ws)
  (if (< *p* (length *s*)) (char *s* *p*) nil))

(defun parse-primary ()
  (let ((c (peek)))
    (cond ((eql c #\()
           (incf *p*)
           (let ((v (parse-expr)))
             (when (eql (peek) #\)) (incf *p*))
             v))
          (t
           (let ((v 0))
             (loop while (and (< *p* (length *s*))
                              (digit-char-p (char *s* *p*)))
                   do (setf v (+ (* v 10) (digit-char-p (char *s* *p*))))
                      (incf *p*))
             v)))))

(defun parse-term ()
  (let ((v (parse-primary)))
    (loop
      (let ((c (peek)))
        (cond ((eql c #\*) (incf *p*) (setf v (* v (parse-primary))))
              ((eql c #\/) (incf *p*) (setf v (truncate v (parse-primary))))
              (t (return v)))))))

(defun parse-expr ()
  (let ((v (parse-term)))
    (loop
      (let ((c (peek)))
        (cond ((eql c #\+) (incf *p*) (setf v (+ v (parse-term))))
              ((eql c #\-) (incf *p*) (setf v (- v (parse-term))))
              (t (return v)))))))

(loop for line = (read-line *standard-input* nil nil)
      while line
      do (let ((trimmed (string-trim '(#\Space #\Tab #\Return) line)))
           (when (> (length trimmed) 0)
             (setf *s* trimmed *p* 0)
             (format t "~D~%" (parse-expr)))))
