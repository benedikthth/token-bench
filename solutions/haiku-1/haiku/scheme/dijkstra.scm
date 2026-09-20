(define (dijkstra n edges start end)
  ;; If start and end are the same, distance is 0
  (if (= start end)
    0
    ;; Build adjacency list from edges
    (let ((adj (make-vector n '())))
      (for-each (lambda (edge)
        (let ((u (car edge))
              (v (cadr edge))
              (w (caddr edge)))
          ;; Undirected edge - add both directions
          (vector-set! adj u (cons (list v w) (vector-ref adj u)))
          (vector-set! adj v (cons (list u w) (vector-ref adj v)))))
        edges)

      ;; Dijkstra's algorithm
      (let ((dist (make-vector n +inf.0))
            (visited (make-vector n #f)))
        ;; Initialize distance to start node as 0
        (vector-set! dist start 0)

        ;; Process all nodes
        (let loop ((count 0))
          (if (< count n)
            ;; Find unvisited node with minimum distance
            (let ((u (let find-min ((i 0) (min-idx -1) (min-val +inf.0))
                       (if (< i n)
                         (if (and (not (vector-ref visited i))
                                  (< (vector-ref dist i) min-val))
                           (find-min (+ i 1) i (vector-ref dist i))
                           (find-min (+ i 1) min-idx min-val))
                         min-idx))))
              (if (< u 0)
                ;; No more reachable nodes
                (let ((final-dist (vector-ref dist end)))
                  (if (>= final-dist +inf.0)
                    -1
                    (truncate final-dist)))
                ;; Mark node as visited
                (begin
                  (vector-set! visited u #t)
                  ;; Update distances to neighbors
                  (for-each (lambda (neighbor)
                    (let ((v (car neighbor))
                          (w (cadr neighbor)))
                      (let ((new-dist (+ (vector-ref dist u) w)))
                        (if (< new-dist (vector-ref dist v))
                          (vector-set! dist v new-dist)))))
                    (vector-ref adj u))
                  (loop (+ count 1)))))
            ;; All nodes processed
            (let ((final-dist (vector-ref dist end)))
              (if (>= final-dist +inf.0)
                -1
                (truncate final-dist)))))))))

;; Main program
;; Read n (number of nodes) and m (number of edges)
(let ((n (read)) (m (read)))
  ;; Read m edges
  (let ((edges (let read-edges ((i 0) (acc '()))
                 (if (< i m)
                   (read-edges (+ i 1)
                              (cons (list (read) (read) (read)) acc))
                   (reverse acc)))))
    ;; Read start node and target node
    (let ((s (read)) (t (read)))
      ;; Compute and output shortest path
      (display (dijkstra n edges s t))
      (newline))))
