(defun matching-bracket (open)
  "Return the closing bracket for the given opening bracket"
  (case open
    (#\( #\))
    (#\[ #\])
    (#\{ #\})))

(defun is-balanced (line)
  "Check if a line has balanced and correctly nested brackets"
  (let ((stack '()))
    (loop for char across line do
      (cond
        ;; Opening brackets - push to stack
        ((or (char= char #\() (char= char #\[) (char= char #\{))
         (push char stack))
        ;; Closing brackets - check against stack
        ((or (char= char #\)) (char= char #\]) (char= char #\}))
         (if (and stack (char= (matching-bracket (car stack)) char))
           (pop stack)
           (return-from is-balanced nil)))))
    ;; Stack must be empty for balanced brackets
    (null stack)))

(loop for line = (read-line *standard-input* nil)
      while line do
  (if (is-balanced line)
    (write-line "yes")
    (write-line "no")))
