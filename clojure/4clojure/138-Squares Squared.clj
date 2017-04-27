(fn squares [start end]
  (let [squares (loop [current start res []]
                  (if (> current end) res
                    (recur (* current current) (conj res current))))
        str_squares (map str squares)
        matrix_size (let [num_of_digits (apply + (map count str_squares))]
                      (int (Math/sqrt (first (filter #(>= % num_of_digits) (map #(* % %) (range)))))))
        empty_matrix (fn [m_size c] (vec (replicate m_size (vec (replicate m_size c)))))
        get-center (let [m_count (dec matrix_size)]
                     (if (even? m_count)
                       [(/ m_count 2) (/ m_count 2)]
                       [(/ (dec m_count) 2) (/ (dec m_count) 2)]))
        num_seq_stream (apply concat str_squares)
        build_path (flatten
                     (loop [counter 1 res [] directions (cycle [:right :down :left :up])]
                         (if (= counter matrix_size) (concat res (map #(repeat counter %) (take 3 directions)))
                           (recur (inc counter) (concat res (map #(repeat counter %) (take 2 directions))) (drop 2 directions)))))
        new_position (fn [[a b] movement]
                       (cond
                         (= movement :up) [(+ a -1) b]
                         (= movement :down) [(+ a 1) b]
                         (= movement :right) [a (+ b 1)]
                         (= movement :left) [a (+ b -1)]))
        build_matrix (loop [matrix (empty_matrix matrix_size \*) current_position get-center path build_path numbers num_seq_stream]
                       ;(println current_position (new_position current_position (first path)) (first path) (first numbers))
                       (if (or (empty? path) (nil? numbers)) matrix
                         (do
                           (recur (update-in matrix current_position (fn [a] (first numbers)))
                                  (new_position current_position (first path)) 
                                  (next path) 
                                  (next numbers)))))
        build_shifted_matrix (fn [matrix length]
                               (let [shift (fn [init values length]
                                             (loop [v (flatten values) c 0 res []]
                                               (cond
                                                 (= c length) res
                                                 (empty? v) (recur v (inc c) (conj res -1))
                                                 (< c init) (recur v (inc c) (conj res -1))
                                                 :else (recur (rest v) (inc c) (conj res (first v))))))]
                                 (map-indexed #(shift %1 %2 length) matrix)))
        shifted_values_sequence (fn [matrix]
                                  (for [y (range (count (first matrix))) x (range (dec (count matrix)) -1 -1)
                                        :when (not= -1 (get-in (vec matrix) [x y]))]
                                    (get-in (vec matrix) [x y])))
        gen-positions-rotated-matrix (fn [n]
                                       (let [columns (let [g (fn [v]
                                                               (distinct (flatten (map (fn [n] [(dec n) (inc n)]) v))))
                                                           values (loop [seed [(/ (dec n) 2)] res [seed] c (/ (dec n) 2)]
                                                                    (if (zero? c)
                                                                      res
                                                                      (recur (g seed) (conj res (g seed)) (dec c))))]
                                                       (concat values (reverse (butlast values))))]
                                         (map-indexed (fn [x y] (map #(vector x %) y)) columns)))
        build-rotated-matrix (let [m1 (empty_matrix (dec (* matrix_size 2)) \ )
                                   s1 (shifted_values_sequence (build_shifted_matrix build_matrix (dec (* matrix_size 2))))
                                   g1 (apply concat (gen-positions-rotated-matrix (dec (* matrix_size 2))))]
                               ;(println m1 s1 g1)
                               (loop [m m1 g g1 s s1]
                                 (if (empty? g) m 
                                   (recur (update-in m (first g) (fn [a] (first s)))
                                          (rest g)
                                          (rest s)))))]
    (map #(apply str %) build-rotated-matrix)))