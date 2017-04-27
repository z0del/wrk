(fn t103 [k s]
  (letfn [(combs [k s]
            (cond  
              (zero? k) [[]]
              (> k (count s)) []
              (= k (count s)) [s]
              :else (apply conj    
                      (map #(conj % (first s)) (t103 (- k 1) (rest s)))
                      (t103 k (rest s)))))]
    (set (for [x (combs k s)] (set x)))))