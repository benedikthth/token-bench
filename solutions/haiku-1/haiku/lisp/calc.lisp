#!/usr/bin/env sbcl --script

;;; Tokenizer - converts input string into list of tokens
(defun tokenize (str)
  "Convert string into list of tokens (numbers, operators, parentheses)"
  (let ((tokens '())
        (len (length str)))
    (do ((i 0 (1+ i)))
        ((>= i len))
      (let ((ch (aref str i)))
        (cond
          ;; Skip whitespace
          ((char= ch #\Space))

          ;; Operators and parentheses
          ((member ch '(#\+ #\- #\* #\/ #\( #\)))
           (push (intern (string ch)) tokens))

          ;; Numbers
          ((digit-char-p ch)
           (let ((start i))
             (do ((j i (1+ j)))
                 ((or (>= j len) (not (digit-char-p (aref str j))))
                  (setf i (1- j)))
               )
             (push (parse-integer (subseq str start (+ i 1))) tokens))))))
    (reverse tokens)))

;;; Parser using recursive descent with operator precedence
(defclass parser ()
  ((tokens :initarg :tokens :accessor parser-tokens)
   (pos :initform 0 :accessor parser-pos)))

(defun make-parser (tokens)
  (make-instance 'parser :tokens tokens))

(defun current-token (parser)
  "Get current token without consuming it"
  (if (< (parser-pos parser) (length (parser-tokens parser)))
      (aref (parser-tokens parser) (parser-pos parser))
      nil))

(defun consume-token (parser)
  "Consume and return current token"
  (let ((token (current-token parser)))
    (incf (parser-pos parser))
    token))

(defun parse-expression (parser)
  "Parse expression: handles + and - (lowest precedence)"
  (let ((left (parse-term parser)))
    (loop while (member (current-token parser) '(+ -))
          do (let ((op (consume-token parser)))
               (let ((right (parse-term parser)))
                 (setf left (if (eq op '+)
                               (+ left right)
                               (- left right))))))
    left))

(defun parse-term (parser)
  "Parse term: handles * and / (higher precedence)"
  (let ((left (parse-factor parser)))
    (loop while (member (current-token parser) '(* /))
          do (let ((op (consume-token parser)))
               (let ((right (parse-factor parser)))
                 (setf left (if (eq op '*)
                               (* left right)
                               (truncate left right))))))
    left))

(defun parse-factor (parser)
  "Parse factor: handles numbers and parentheses"
  (let ((token (current-token parser)))
    (cond
      ;; Number
      ((numberp token)
       (consume-token parser)
       token)

      ;; Parenthesized expression
      ((eq token '|(|)
       (consume-token parser)  ;; consume '('
       (let ((result (parse-expression parser)))
         (consume-token parser)  ;; consume ')'
         result))

      ;; Error
      (t (error "Unexpected token: ~A" token)))))

(defun evaluate (expr-str)
  "Parse and evaluate an expression string"
  (let* ((tokens (tokenize expr-str))
         (tokens-array (make-array (length tokens) :initial-contents tokens))
         (parser (make-parser tokens-array)))
    (parse-expression parser)))

;;; Main loop - read lines and evaluate
(defun main ()
  (loop
    (let ((line (read-line nil nil)))
      (if (null line)
          (return)
          (let ((result (evaluate line)))
            (format t "~D~%" result))))))

(main)
