(fn veitch [ms]
  (let [miniterm_to_int (fn [m]
                          (let [to_int_4 #(cond (= %1 'A) 8
                                                (= %1 'B) 4
                                                (= %1 'C) 2
                                                (= %1 'D) 1
                                                :else 0)
                                to_int_3 #(cond (= %1 'A) 4
                                                (= %1 'B) 2
                                                (= %1 'C) 1
                                                :else 0)]
                            (if (= 4 (count m))
                              (apply + (map to_int_4 m))
                              (apply + (map to_int_3 m)))))
        miniterm_len (count (first ms))
        swap (fn [v i1 i2] (assoc v i2 (v i1) i1 (v i2)))
        transpose (fn [m] (apply mapv vector m))
        ones (set (map miniterm_to_int ms))
        tmp_matrix (let [values (map #(if (ones %1) 1 0) (range (Math/pow 2 miniterm_len)))]
                     (if (= miniterm_len 4)
                       (transpose (partition 4 values))
                       [(take-nth 2 values) (take-nth 2 (rest values))]))
        matrix (if (= miniterm_len 4)
                 (swap (vec (map #(swap (vec %1) 2 3) tmp_matrix)) 2 3)
                 (vec (map #(swap (vec %1) 2 3) tmp_matrix)))
        one_positions (set (for [[row r-val] (map-indexed vector matrix)
                                 [column c-val] (map-indexed vector r-val) :when (= 1 c-val)]
                             [row column]))
        compute_rectangles (fn [position]
                             (let [len (inc (count matrix))
                                   ranges (for [x (range 1 len) y (range 1 len) 
                                                :when (or (and (even? x) (even? y)) 
                                                          (and (= x 1) (even? y)) 
                                                          (and (= y 1) (even? x)))] 
                                            [x y])
                                   compute_rectange_elements (fn [[x y]]
                                                               (for [x1 (range x) y1 (range y)]
                                                                 [x1 y1]))
                                   rectangle_elements (map compute_rectange_elements ranges)]
                               (conj (for [x rectangle_elements] (map #(map + position %) x))
                                     [position])))
        filter_rectangles (fn [rectangles]
                            (let [temp1 (map (fn [x] (filter #(every? one_positions %) x)) rectangles)
                                  temp2 (map #(reduce (fn [x y] (if (> (count x) (count y)) x y)) [] %) temp1)
                                  temp3 (set (map set temp2))
                                  temp4 (set (for [t temp3 :when (every? (fn [x] (not (clojure.set/subset? t x))) (disj temp3 t))] t))]
                              (for [t temp4 :when (not (every? identity (let [s (disj temp4 t)]
                                                                          (map (fn [t1] (some #(% t1) s)) t))))] t)))
                              ;(for [t temp3 :when (every? (fn [x] (not (clojure.set/subset? t x))) (disj temp3 t))] t)))
        get_rectangles (let [rectangles (set (filter_rectangles (map compute_rectangles one_positions)))
                             s (if (and (one_positions [0 1]) (one_positions [0 2])
                                        (one_positions [3 1]) (one_positions [3 2]))
                                  (conj (disj (disj rectangles #{[0 1] [0 2]}) #{[3 1] [3 2]})
                                        #{[0 1] [0 2] [3 1] [3 2]})
                                  rectangles)
                             t (if (and (one_positions [1 0]) (one_positions [2 0])
                                        (one_positions [1 3]) (one_positions [2 3]))
                                 (conj (disj (disj s #{[1 0] [2 0]}) #{[1 3] [2 3]})
                                       #{[1 0] [2 0] [1 3] [2 3]})
                                 s)
                             r (if (and (one_positions [0 0]) (one_positions [0 3])
                                        (one_positions [3 0]) (one_positions [3 3]))
                                  (conj (disj (disj (disj (disj t #{[0 0]}) #{[0 3]}) #{[3 0]}) #{[3 3]})
                                        #{[0 0] [0 3] [3 0] [3 3]})
                                  t)]
                         r)
        analyze_rectangle_3 (fn [rectangle]
                              (cond
                                (= (count rectangle) 4)
                                   (let [x1 (map first rectangle) y1 (map second rectangle)
                                         x2 (sort (set x1)) y2 (sort (set y1))]
                                     (cond
                                       (= x2 [0]) #{'c}
                                       (= x2 [1]) #{'D}
                                       (= y2 [0 1]) #{'a}
                                       (= y2 [1 2]) #{'B}
                                       (= y2 [2 3]) #{'A}
                                       :else #{'b}))
                                (= (count rectangle) 2)
                                   (let [x (set (map first rectangle))
                                         y (set (map second rectangle))
                                         f (if (= (count x) 1)
                                             (if (= #{0}) #{'c} #{'C})
                                             #{})
                                         s (if (= (count y) 1)
                                             (cond
                                               (= (first y) 0) #{'a 'b} (= (first y) 1) #{'a 'B}
                                               (= (first y) 2) #{'A 'B} (= (first y) 3) #{'A 'b})
                                             (cond
                                               (= y #{0 1}) #{'a} (= y #{1 2}) #{'B}
                                               (= y #{2 3}) #{'A} (= y #{0 3}) #{'b}))]
                                     (clojure.set/union f s))
                                :else
                                     (cond
                                       (= rectangle #{[0 0]}) #{'a 'b 'c}
                                       (= rectangle #{[0 1]}) #{'a 'B 'c}
                                       (= rectangle #{[0 2]}) #{'A 'B 'c}
                                       (= rectangle #{[0 3]}) #{'A 'b 'c}
                                       (= rectangle #{[1 0]}) #{'a 'b 'C}
                                       (= rectangle #{[1 1]}) #{'a 'B 'C}
                                       (= rectangle #{[1 2]}) #{'A 'B 'C}
                                       (= rectangle #{[1 3]}) #{'A 'b 'C})))
        analyze_rectangle_4 (fn [rectangle]
                              (cond
                                (= (count rectangle) 4) 
                                   (let [x1 (map first rectangle) y1 (map second rectangle)
                                         x2 (sort (set x1)) y2 (sort (set y1))]
                                     (cond
                                       (every? #(= (first x1) %) x1) (cond 
                                                                       (= (first x1) 0) #{'c 'd}
                                                                       (= (first x1) 1) #{'c 'D}
                                                                       (= (first x1) 2) #{'C 'D}
                                                                       :else #{'C 'd})
                                       (every? #(= (first y1) %) y1) (cond 
                                                                       (= (first y1) 0) #{'a 'b}
                                                                       (= (first y1) 1) #{'a 'B}
                                                                       (= (first y1) 2) #{'A 'B}
                                                                       :else #{'A 'b})
                                         
                                       :else (let [f (cond
                                                       (= x2 [0 1]) 'c (= x2 [1 2]) 'D
                                                       (= x2 [2 3]) 'C (= x2 [0 3]) 'd)
                                                   s (cond
                                                      (= y2 [0 1]) 'a (= y2 [1 2]) 'B
                                                      (= y2 [2 3]) 'A (= y2 [0 3]) 'b)]
                                               #{f s})))
                                (= (count rectangle) 2)
                                   (let [x (set (map first rectangle))
                                         y (set (map second rectangle))
                                         f (if (= (count x) 1)
                                             (cond
                                               (= (first x) 0) #{'c 'd} (= (first x) 1) #{'c 'D}
                                               (= (first x) 2) #{'C 'D} (= (first x) 3) #{'C 'd})
                                             (cond
                                               (= x #{0 1}) #{'c} (= x #{1 2}) #{'D}
                                               (= x #{2 3}) #{'C} (= x #{0 3}) #{'d}))
                                         s (if (= (count y) 1)
                                             (cond
                                               (= (first y) 0) #{'a 'b} (= (first y) 1) #{'a 'B}
                                               (= (first y) 2) #{'A 'B} (= (first y) 3) #{'A 'b})
                                             (cond
                                               (= y #{0 1}) #{'a} (= y #{1 2}) #{'B}
                                               (= y #{2 3}) #{'A} (= y #{0 3}) #{'b}))]
                                     (clojure.set/union f s))
                                :else
                                   (cond
                                     (= rectangle #{[0 0]}) #{'a 'b 'c 'd}
                                     (= rectangle #{[0 1]}) #{'a 'B 'c 'd}
                                     (= rectangle #{[0 2]}) #{'A 'B 'c 'd}
                                     (= rectangle #{[0 3]}) #{'A 'b 'c 'd}
                                     (= rectangle #{[1 0]}) #{'a 'b 'c 'D}
                                     (= rectangle #{[1 1]}) #{'a 'B 'c 'D}
                                     (= rectangle #{[1 2]}) #{'A 'B 'c 'D}
                                     (= rectangle #{[1 3]}) #{'A 'b 'c 'D}
                                     (= rectangle #{[2 0]}) #{'a 'b 'C 'D}
                                     (= rectangle #{[2 1]}) #{'a 'B 'C 'D}
                                     (= rectangle #{[2 2]}) #{'A 'B 'C 'D}
                                     (= rectangle #{[2 3]}) #{'A 'b 'C 'D}
                                     (= rectangle #{[3 0]}) #{'a 'b 'C 'd}
                                     (= rectangle #{[3 1]}) #{'a 'B 'C 'd}
                                     (= rectangle #{[3 2]}) #{'A 'B 'C 'd}
                                     (= rectangle #{[3 3]}) #{'A 'b 'C 'd})))]
    ;(println ones matrix)
    ;(println one_positions)
    ;(println get_rectangles)
    (if (= (count (first ms)) 4)
           (set (map analyze_rectangle_4 get_rectangles))
           (set (map analyze_rectangle_3 get_rectangles)))))