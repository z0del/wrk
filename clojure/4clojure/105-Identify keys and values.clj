(fn t10 [vals]
  (if (empty? vals)
    {}
    (apply hash-map (loop [res [(first vals)] v (rest vals) temp []]
                      (if (empty? v)
                        (conj res temp)
                         (cond
                           (keyword? (first v)) (recur (conj res temp (first v)) (rest v) [])
                           :else (recur res (rest v) (conj temp (first v)))))))))