(defun is-letter-p (char)
  "Check if a character is an ASCII letter (a-z or A-Z)."
  (or (char<= #\a char #\z)
      (char<= #\A char #\Z)))

(defun extract-words (text)
  "Extract all words from text, where a word is a maximal run of ASCII letters.
   Words are converted to lowercase."
  (let ((words nil)
        (current-word nil))
    (loop for char across text
          do (if (is-letter-p char)
                 (push (char-downcase char) current-word)
                 (when current-word
                   (push (coerce (nreverse current-word) 'string) words)
                   (setq current-word nil))))
    ;; Don't forget the last word
    (when current-word
      (push (coerce (nreverse current-word) 'string) words))
    (nreverse words)))

(defun count-words (words)
  "Count occurrences of each word using a hash table."
  (let ((freq (make-hash-table :test #'equal)))
    (loop for word in words
          do (setf (gethash word freq) (1+ (gethash word freq 0))))
    freq))

(defun sort-results (freq-table)
  "Convert hash table to sorted list of (word . count) pairs.
   Sorted by count descending, then by word ascending."
  (let ((pairs nil))
    (maphash (lambda (key value)
               (push (cons key value) pairs))
             freq-table)
    (sort pairs
          (lambda (a b)
            (if (= (cdr a) (cdr b))
                ;; Same count: sort by word ascending
                (string< (car a) (car b))
                ;; Different count: sort by count descending
                (> (cdr a) (cdr b)))))))

(defun main ()
  "Main function: read input, count words, and print sorted results."
  (let ((input (make-string-output-stream)))
    ;; Read all input lines
    (loop for line = (read-line *standard-input* nil nil)
          while line
          do (write-line line input))

    ;; Process and output
    (let* ((text (get-output-stream-string input))
           (words (extract-words text))
           (freq-table (count-words words))
           (sorted (sort-results freq-table)))
      (loop for (word . count) in sorted
            do (format t "~a ~d~%" word count)))))

(main)
