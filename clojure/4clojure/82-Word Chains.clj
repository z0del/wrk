(fn t89 [ words ]
  (let [next_permutation (fn [ s ]
                (if (zero? (count (drop-while #(> % 0) (map #(compare (second %) (first %)) (partition 2 1 (reverse s))))))
                  nil
                  (let [rev (reverse s)
                        swap (fn [ v i1 i2 ] (assoc (vec v) i2 ((vec v) i1) i1 ((vec v) i2)))
                        k (dec (count (drop-while #(> % 0) (map #(compare (second %) (first %)) (partition 2 1 rev)))))
                        k_val (nth s k)
                        l (dec (count (drop-while #(> 0 (compare % k_val)) rev)))
                        r (swap s k l)]
                    (concat (take (inc k) r) (reverse (drop (inc k) r))))))                                  
        diffs (fn [w] 
                (let [a (if (> (count (first w))
                                (count (second w)))
                           (first w)
                           (second w))
                      b (if (> (count (first w))
                               (count (second w)))
                          (second w)
                          (first w))
                      c (count (clojure.set/difference (set a) (set b)))]
                  (if (> (- (count a) (count b)) 1)
                    0
                    (if (= c 0)
                      (- (count a) (count b))
                      c))))]
    (loop [w (sort (vec words))]
      (cond
        (nil? w) false
        (every? #(= % 1) (map diffs (partition 2 1 w))) true
        :else (recur (next_permutation w))))))