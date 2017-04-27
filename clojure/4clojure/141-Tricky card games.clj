(fn t141 [ winner ]
  (fn [cards]
    (let [w_c (if winner   
              winner
              (:suit (first cards)))
          g (filter #(= (:suit %) w_c ) cards)]
      (first (sort-by :rank > g)))))