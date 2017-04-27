(fn t131 [& sets]
  (let [combinations (fn [n s]
                         (set (filter #(= n (count %)) (reduce (fn [s v] (concat s (map #(conj % v) s))) [#{}] s))))
        power_set (fn [s]
                  (for [x (range 1 (inc (count s)))]
                    (combinations x s)))
        subsets (map #(apply clojure.set/union (power_set %)) sets)
        subsets_sums (for [s subsets] (set (map #(apply + %) s)))]
    (>= (count (apply clojure.set/intersection subsets_sums)) 1)))