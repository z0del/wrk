(fn [coll1 coll2]
  (loop [c1 coll1 c2 coll2 result []]
    (if (or (empty? c1) (empty? c2))
      (apply array-map result)
      (recur (rest c1) (rest c2) (conj result (first c1) (first c2))))))