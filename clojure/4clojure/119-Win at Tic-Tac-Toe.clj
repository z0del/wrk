(fn winTicTacToe [m [a b c]]
  (let [isVictory? (fn [[a b c]]
                     (let [f_rx #(= m %)]
                       (cond
                         (or (every? f_rx a) (every? f_rx b) (every? f_rx c)) true
                         (and (= (nth a 0) m) (= (nth b 0) m) (= (nth c 0) m)) true
                         (and (= (nth a 1) m) (= (nth b 1) m) (= (nth c 1) m)) true
                         (and (= (nth a 2) m) (= (nth b 2) m) (= (nth c 2) m)) true
                         (and (= (nth a 0) m) (= (nth b 1) m) (= (nth c 2) m)) true
                         (and (= (nth a 2) m) (= (nth b 1) m) (= (nth c 0) m)) true
                         :else false)))
        free_first_row (for [[x y] (map-indexed vector a) :when (and (= y :e) (isVictory? [(assoc a x m) b c]))] [0 x])
        free_second_row (for [[x y] (map-indexed vector b) :when (and (= y :e) (isVictory? [a (assoc b x m) c]))] [1 x])
        free_third_row (for [[x y] (map-indexed vector c) :when (and (= y :e) (isVictory? [a b (assoc c x m)]))] [2 x])]
    (set (concat free_first_row free_second_row free_third_row))))