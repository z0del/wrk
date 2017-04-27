(fn t9 [coll]
  (let [next_val (flatten (map #(list (count %1) (first %1)) (partition-by identity coll)))]
    (lazy-seq (cons next_val (t9 next_val)))))