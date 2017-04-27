(fn solve_maze [maze]
  (let [m_pos (first (first (filter not-empty (for [[row_v row] (map-indexed vector maze)]
                                                (for [[col_v value] (map-indexed vector row) :when (= value \C)]
                                                  [row_v col_v])))))
        c_pos (first (first (filter not-empty (for [[row_v row] (map-indexed vector maze)]
                                                (for [[col_v value] (map-indexed vector row) :when (= value \M)]
                                                  [row_v col_v])))))
        emtpy_positions (set (apply concat (filter not-empty (for [[row_v row] (map-indexed vector maze)]
                                                               (for [[col_v value] (map-indexed vector row) :when (or (= value \ ) (= value \M))]
                                                                 [row_v col_v])))))
        check_position (fn [d [a b] positions]
                         (cond
                           (= d :up) [[(inc a) b] (contains? positions [(inc a) b])]
                           (= d :down) [[(dec a) b] (contains? positions [(dec a) b])]
                           (= d :right) [[a (inc b)] (contains? positions [a (inc b)])]
                           (= d :left) [[a (dec b)] (contains? positions [a (dec b)])]))]
    (letfn [(traverse_maze [current_position free_positions]
                           ;(println current_position free_positions)
                           (cond
                             (= current_position c_pos) true
                             :else (let [[up_pos up_available] (check_position :up current_position free_positions)
                                         [down_pos down_available] (check_position :down current_position free_positions)
                                         [left_pos left_available] (check_position :left current_position free_positions)
                                         [right_pos right_available] (check_position :right current_position free_positions)]
                                     (or (if up_available (traverse_maze up_pos (disj free_positions up_pos)) false)
                                         (if down_available (traverse_maze down_pos (disj free_positions down_pos)) false)
                                         (if left_available (traverse_maze left_pos (disj free_positions left_pos)) false)
                                         (if right_available (traverse_maze right_pos (disj free_positions right_pos)) false)))))]
      (traverse_maze m_pos emtpy_positions))))