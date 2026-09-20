;;; Expression calculator: recursive-descent parser over a string.

(defvar *s* "")
(defvar *pos* 0)

(defun skip-spaces ()
  (loop while (and (< *pos* (length *s*))
                   (member (char *s* *pos*) '(#\Space #\Tab #\Return)))
        do (incf *pos*)))

(defun peek-char* ()
  (skip-spaces)
  (if (< *pos* (length *s*)) (char *s* *pos*) nil))

(defun parse-number ()
  (skip-spaces)
  (let ((start *pos*))
    (loop while (and (< *pos* (length *s*)) (digit-char-p (char *s* *pos*)))
          do (incf *pos*))
    (parse-integer *s* :start start :end *pos*)))

(defun parse-factor ()
  (let ((c (peek-char*)))
    (cond ((eql c #\()
           (incf *pos*)
           (let ((v (parse-expr)))
             (when (eql (peek-char*) #\)) (incf *pos*))
             v))
          (t (parse-number)))))

(defun parse-term ()
  (let ((v (parse-factor)))
    (loop
      (let ((c (peek-char*)))
        (cond ((eql c #\*) (incf *pos*) (setf v (* v (parse-factor))))
              ((eql c #\/) (incf *pos*) (setf v (truncate v (parse-factor))))
              (t (return v)))))))

(defun parse-expr ()
  (let ((v (parse-term)))
    (loop
      (let ((c (peek-char*)))
        (cond ((eql c #\+) (incf *pos*) (setf v (+ v (parse-term))))
              ((eql c #\-) (incf *pos*) (setf v (- v (parse-term))))
              (t (return v)))))))

(defun main ()
  (loop for line = (read-line *standard-input* nil nil)
        while line
        do (setf *s* line *pos* 0)
           (when (peek-char*)
             (format t "~D~%" (parse-expr))))
  (finish-output))

(main)
