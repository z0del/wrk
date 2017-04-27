(fn t9 [ & l]
   (letfn [(check [value coll]
             (if (empty? coll)
               false
               (cond
                 (= value (first coll)) true
                 (> value (first coll)) (recur value (rest coll))
                 :else false)
               ))]
     (first (for [x (first l)
           :when (every? true? (map #(check x %) (rest l)))]
         x
       ))))