(fn t1 [coll]
  (set (filter #(> (count %1) 1) (map (fn [word] 
           (set (for [other coll
                :when (= (count word) (count other))
                :when ((fn [s w] (reduce #(and %1 %2) (map #(contains? s %1) w)))
                       (set word) other)]
                  other))) coll))))