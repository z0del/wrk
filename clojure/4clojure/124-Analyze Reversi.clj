(fn reversi [board player]
  (let [opposite (if (= player 'w) 'b 'w)
        empty_pos (set (apply concat 
                              (for [[row_v row] (map-indexed vector board)]
                                (for [[col_v value] (map-indexed vector row) :when (= value 'e)]
                                  [row_v col_v]))))
        player_pos (apply concat
                            (for [[row_v row] (map-indexed vector board)]
                              (for [[col_v value] (map-indexed vector row) :when (= value player)]
                                [row_v col_v])))
        opposite_pos (set (apply concat
                                 (for [[row_v row] (map-indexed vector board)]
                                  (for [[col_v value] (map-indexed vector row) :when (= value opposite)]
                                    [row_v col_v]))))
        generate_positions (fn [[a b]]
                             (for [x [-1 0 1] y [-1 0 1] 
                                   :when (and (>= (+ a x) 0) 
                                              (>= (+ b y) 0) 
                                              (not (and (= x 0) (= y 0))))]
                               [[(+ a x) (+ b y)] [x y]]))
        starting_movements (filter (fn [[v d]] (contains? opposite_pos v)) (apply concat (map generate_positions player_pos))) 
        generate_movements (fn [[v d]]
                             (loop [f v res [v]]
                               (let [n [(+ (first f) (first d)) 
                                        (+ (second f) (second d))]]
                                 (cond 
                                   (contains? opposite_pos n) (recur n (conj res n))
                                   (contains? empty_pos n) [n (set res)]
                                   :else []))))]
    (apply hash-map (apply concat (map generate_movements starting_movements)))))