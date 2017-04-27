(fn t114 [c p coll]
  (let [v (nth (filter p coll) (dec c))]
    (take-while #(not= % v) coll)))