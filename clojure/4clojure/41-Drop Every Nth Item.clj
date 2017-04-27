(fn drop3
  [coll num]
  (loop [s coll counter 1 result []]
    (if (empty? s)
      result
      (if (= (rem counter num) 0)
        (recur (rest s) 1 result)
        (recur (rest s) (inc counter) (conj result (first s)))))))