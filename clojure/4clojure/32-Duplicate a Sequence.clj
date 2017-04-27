(fn dupli
  [coll]
  (loop [s coll result []]
    (if (empty? s)
      result
      (recur (rest s) (concat result (repeat 2 (first s)))))))