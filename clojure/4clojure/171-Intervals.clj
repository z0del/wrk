(fn t171 [coll]
  (let [c (distinct (sort coll))
        answer (concat [(first c)]
                       (flatten (filter #(not= (- (second %) (first %)) 1) (partition 2 1 c)))
                       [(last c)])]
    (if (empty? coll)
      []
      (partition 2 2 answer))))