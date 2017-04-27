(fn P63 [ func list ]
  (loop [a (distinct (map func list)) result (hash-map)]
         (if (empty? a)
           result
           (recur (rest a) (assoc result (first a) (loop [temp list r []] 
                                                    (if (empty? temp) 
                                                      r 
                                                      (if (= (first a) (func (first temp))) 
                                                        (recur (rest temp) (conj r (first temp))) 
                                                        (recur (rest temp) r)))))))))