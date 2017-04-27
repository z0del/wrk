(fn P99 [ & l]
  (let [res (apply * l)]
    (loop [value res result []]
      (if (< value 9)
        (if (= value 0)
          (reverse result)
          (reverse (conj result value)))
        (recur (int (/ value 10)) (conj result (rem value 10)))))))