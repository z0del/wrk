(fn P143 [ c1 c2 ]
  (loop [ c1 c1 c2 c2 result []]
    (if (empty? c1)
      (apply + result)
      (recur (rest c1) (rest c2) (conj result (* (first c1) (first c2)))))))