(fn t91 [edges]
 (let [nodes (set (apply concat edges))]
   (loop [visited #{} to_visit [(first edges)]]
     (if (empty? to_visit)
       (= visited nodes)
       (let [[a b] (first to_visit)]
         (recur (conj visited a b)
                (concat (rest to_visit) 
                        (for [x edges
                              :when (not (visited (second x)))
                              :when (or (= b (first x)) (= a (first x)))]
                          x))))))))