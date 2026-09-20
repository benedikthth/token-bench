(defun canonical-form (word)
  "Return the letters of word in sorted order as a string"
  (coerce (sort (coerce word 'list) #'char<) 'string))

(let ((words '()))
  ;; Read all words from input
  (loop for line = (read-line nil nil)
        while line
        when (> (length line) 0)
        do (push line words))

  ;; Group words by canonical form
  (let ((groups (make-hash-table :test #'equal)))
    (dolist (word words)
      (let ((canonical (canonical-form word)))
        (setf (gethash canonical groups)
              (cons word (gethash canonical groups '())))))

    ;; Convert hash table to list of groups and sort within each group
    (let ((groups-list '()))
      (maphash (lambda (k v)
                 (push (sort v #'string<) groups-list))
               groups)

      ;; Sort groups by their first word
      (setf groups-list (sort groups-list
                              (lambda (g1 g2)
                                (string< (car g1) (car g2)))))

      ;; Output
      (dolist (group groups-list)
        (format t "~{~a~^ ~}~%" group)))))
