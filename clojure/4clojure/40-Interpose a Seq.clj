(fn interp
  [value coll]
  (loop [s coll result []]
    (if (empty? s)
       (drop-last result)
       (recur (rest s) (conj result (first s) value)))))