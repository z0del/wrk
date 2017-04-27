(fn P120 [ coll ]
  (loop [c coll result 0]
    (if (empty? c)
      result
      (if (< (first c) (reduce + (map #(* % %) (map #(- % 48) (map int (str (first c)))))))
        (recur (rest c) (inc result))
        (recur (rest c) result)))))