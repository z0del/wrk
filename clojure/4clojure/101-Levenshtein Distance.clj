(fn levenshtein [str1 str2]
  (let [c1 (count str1) c2 (count str2)
        new_row (fn [c v0] (loop [pos 0 ans [(inc c)]]
                          (if (= pos c2)
                            ans
                            (let [cost (if (or (>= pos c1) (= (nth str1 pos) (nth str2 pos))) 0 1)]
                              (recur (inc pos)
                                     (conj ans (min (+ 1 (last ans)) (+ (nth v0 (inc pos)) 1) (+ (nth v0 pos) cost))))))))]
    (cond
      (= str1 str2) 0
      (zero? (min c1 c2)) (max c1 c2)
      :else
        (loop [v0 (reduce #(conj %1 %2) [] (range (inc c2))) c 0]
          (if (= c (count str2))
            (if (= c1 c2) (last v0) (inc (last v0)))
            (recur (new_row c v0) (inc c)))))))