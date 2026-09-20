(defun dijkstra (n edges start target)
  ;; Special case: start equals target
  (when (= start target)
    (return-from dijkstra 0))

  ;; Build adjacency list
  (let ((graph (make-array n :initial-element nil)))
    (dolist (edge edges)
      (destructuring-bind (u v w) edge
        (push (cons v w) (aref graph u))
        (push (cons u w) (aref graph v))))

    ;; Dijkstra's algorithm
    (let ((dist (make-array n :initial-element most-positive-fixnum))
          (visited (make-array n :initial-element nil)))
      (setf (aref dist start) 0)

      (dotimes (i n)
        ;; Find unvisited node with minimum distance
        (let ((min-dist most-positive-fixnum)
              (min-node -1))
          (dotimes (j n)
            (when (and (not (aref visited j))
                       (< (aref dist j) min-dist))
              (setf min-dist (aref dist j))
              (setf min-node j)))

          (if (= min-node -1)
              (return) ;; No more reachable nodes
              (progn
                (setf (aref visited min-node) t)
                ;; Relax edges from this node
                (dolist (edge (aref graph min-node))
                  (destructuring-bind (neighbor . weight) edge
                    (when (< (+ (aref dist min-node) weight)
                             (aref dist neighbor))
                      (setf (aref dist neighbor)
                            (+ (aref dist min-node) weight)))))))))

      ;; Return result
      (if (= (aref dist target) most-positive-fixnum)
          -1
          (aref dist target)))))

;; Main program
(let* ((n (read))
       (m (read))
       (edges (loop for i below m collect (list (read) (read) (read))))
       (s (read))
       (t-node (read)))
  (format t "~A~%" (dijkstra n edges s t-node)))
