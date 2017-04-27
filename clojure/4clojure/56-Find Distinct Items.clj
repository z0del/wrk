(fn unique
   [coll]
   (loop [s coll result []]
     (if (empty? s)
       result
       (if ((fn [coll v]
              (if (empty? coll)
                false
                (if (= (first coll) v)
                  true
                  (recur (rest coll) v))))  result (first s))
         (recur (rest s) result)
         (recur (rest s) (conj result (first s)))))))