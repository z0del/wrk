(fn t7 [coll]
  (cons coll 
        (lazy-seq
          (let [ans (map #(apply +' %1) (partition 2 1 coll))
                f (first coll)
                l (last coll)]
            (t7 (concat [f] ans [l]))))))