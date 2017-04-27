(fn t12 [coll]
  (let [l #(loop [res [(first %)] c (rest %)]
             (if (or (empty? c) (not= (last res) (- (first c) 1)))
               (if (= (count res) 1)
                 []
                 res)
               (recur (conj res (first c))(rest c))))]
    (reduce #(if (< (count %2) (count %1))
               %1
               %2)
            (loop [res [] c coll]
              (if (empty? c)
                res
                (recur (conj res (l c)) (rest c)))))))