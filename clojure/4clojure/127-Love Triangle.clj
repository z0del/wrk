(fn lovetriangle [values]
  (let [get_binary (fn [n]
                     (loop [n n res '()]
                       (cond
                         (zero? n) res
                         (odd? n) (recur (quot n 2) (conj res 1))
                         :else (recur (quot n 2) (conj res 0)))))
        shift_values (fn [coll]
                       (let [max_value (apply max (map count coll))]
                         (map #(concat (repeat (- max_value (count %)) 0) %) coll)))
        stone (map vec (shift_values (map get_binary values)))
        one_positions (set (for [[row r-val] (map-indexed vector stone)
                                 [column c-val] (map-indexed vector r-val) :when (= 1 c-val)]
                             [row column]))
        check_position (fn [r s e f_row f_start f_end iter_cols]
                         (loop [row (f_row r) start (f_start s) end (f_end e) res 1]
                           (if (every? #(one_positions %) (for [x (range start end)] (if iter_cols 
                                                                                       [row x]
                                                                                       [x row])))
                             (recur (f_row row) (f_start start) (f_end end) (+ res (- end start)))
                             res)))]
    ;(println stone)
    (let [m (apply max (concat
                         (map (fn [[r c]] (check_position r c (inc c) inc dec inc true)) one_positions)
                         (map (fn [[r c]] (check_position r c (inc c) inc dec identity true)) one_positions)                 
                         (map (fn [[r c]] (check_position r c (inc c) inc identity inc true)) one_positions)
                 
                         (map (fn [[r c]] (check_position r c (inc c) dec dec inc true)) one_positions)
                         (map (fn [[r c]] (check_position r c (inc c) dec dec identity true)) one_positions)                 
                         (map (fn [[r c]] (check_position r c (inc c) dec identity inc true)) one_positions)
                 
                         (map (fn [[r c]] (check_position c r (inc r) inc dec inc false)) one_positions)
                         (map (fn [[r c]] (check_position c r (inc r) dec dec inc false)) one_positions)
                         (map (fn [[r c]] (check_position c r (inc r) inc dec inc false)) one_positions)
                         (map (fn [[r c]] (check_position c r (inc r) dec dec inc false)) one_positions)))]
      (if (> m 2) m nil))))