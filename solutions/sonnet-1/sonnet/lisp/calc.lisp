;;; Expression calculator

(defvar *toks* nil)

(defun tokenize (line)
  (let ((tokens '())
        (i 0)
        (n (length line)))
    (loop while (< i n) do
      (let ((c (char line i)))
        (cond
          ((digit-char-p c)
           (let ((j i))
             (loop while (and (< j n) (digit-char-p (char line j))) do (incf j))
             (push (parse-integer line :start i :end j) tokens)
             (setf i j)))
          ((find c "+-*/()")
           (push (intern (string c) :keyword) tokens)
           (incf i))
          (t (incf i)))))
    (nreverse tokens)))

(defun peek-tok ()
  (car *toks*))

(defun next-tok ()
  (pop *toks*))

(defun parse-expr ()
  (let ((v (parse-term)))
    (loop while (member (peek-tok) '(:+ :-)) do
      (let ((op (next-tok)))
        (let ((rhs (parse-term)))
          (setf v (if (eq op :+) (+ v rhs) (- v rhs))))))
    v))

(defun parse-term ()
  (let ((v (parse-factor)))
    (loop while (member (peek-tok) '(:* :/)) do
      (let ((op (next-tok)))
        (let ((rhs (parse-factor)))
          (setf v (if (eq op :*) (* v rhs) (truncate v rhs))))))
    v))

(defun parse-factor ()
  (let ((tok (next-tok)))
    (cond
      ((integerp tok) tok)
      ((eq tok (intern "(" :keyword))
       (let ((v (parse-expr)))
         (next-tok) ; consume ")"
         v))
      (t (error "unexpected token ~a" tok)))))

(defun main ()
  (loop for line = (read-line *standard-input* nil nil)
        while line
        do (let ((*toks* (tokenize line)))
             (when *toks*
               (format t "~a~%" (parse-expr))))))

(main)
