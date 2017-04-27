(fn repli
  [coll times]
  (loop [s coll result []]
    (if (empty? s)
      result
      (recur (rest s) (concat result (repeat times (first s)))))))