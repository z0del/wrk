(fn latin-square-slicing [matrix]
  (let [generate-variations (fn [m1]
                              (let [m (filter not-empty m1)
                                    max-length (apply max (map count m))
                                    padded-matrix (map #(if (< (count %) max-length)
                                                          (concat % (repeat (- max-length (count %)) nil))
                                                          %)
                                                       m)
                                    cartesian (fn cartesian [colls]
                                                (if (empty? colls)
                                                  '(())
                                                  (for [x (first colls)
                                                        more (cartesian (rest colls))]
                                                    (cons x more))))
                                    round-robin (fn [v]
                                                  (for [x (range (inc (count (filter nil? v))))]
                                                    (concat (repeat x nil) (drop-last x v))))]
                                (cartesian (map round-robin padded-matrix))))
        compute-latin-squares (fn [m]
                                (let [compute-submatrices (fn [m]
                                                            (let [get-starting-position (fn [[x y] m]
                                                                                          (map #(drop y %) (drop x m)))]
                                                              (for [x (range (dec (count m))) y (range (dec (count (get m x))))]
                                                                (get-starting-position [x y] m))))
                                      get-squares (fn [m]
                                                    (let [get-square (fn [size m]
                                                                       (map #(take size %) (take size m)))]
                                                      (map (fn [x] (let [square (get-square x m)]
                                                            (if (every? empty? (map #(filter nil? %) square))
                                                              square
                                                              nil))) 
                                                           (range 2 (inc (count m)))))) 
                                      is-latin-square? (fn [square]
                                                         (when square
                                                           (let [sorted-row (sort (first square))
                                                                 transposed-square (apply map vector square)]
                                                             (every? #(= sorted-row (sort %)) (concat square transposed-square)))))]
                                  (filter is-latin-square? (apply concat (map get-squares (compute-submatrices m))))))
        s (->> 
            ;(for [variation (map #(reduce conj [] %) (generate-variations matrix))]
            ;  (compute-latin-squares variation))
            (map #(compute-latin-squares %) (map #(reduce conj [] %) (generate-variations matrix)))
            (apply concat)
            (set)
            (group-by count))]
    (into {} (for [[k v] s] [k (count v)]))))