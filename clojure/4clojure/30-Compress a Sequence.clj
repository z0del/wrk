(fn rem-duplicates
  [coll]
  (loop [temp-list coll result []]
    (if (empty? temp-list)
      result
      (if (= (first temp-list) (last result))
        (recur (rest temp-list) result)
        (recur (rest temp-list) (conj result (first temp-list)))))))