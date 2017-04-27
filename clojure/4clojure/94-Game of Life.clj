(fn neighbours [board]
  (let [analize_row (fn [r pos]
                (vector (if (and (pos? (count r))  (> (dec pos) 0) (= (nth r (dec pos)) \#))
                          1
                          0)
                        (if (and (pos? (count r)) (= (nth r pos) \#)) 1 0)
                        (if (and (pos? (count r)) (< (inc pos) (count r)) (= (nth r (inc pos)) \#))
                          1
                          0)))
        get_row (fn [[a b c]]
                  (loop [pos 0 res ""]
                    (if (= pos (count b))
                      res
                      (let [current (nth b pos)
                            cells (apply + (concat (analize_row a pos) (analize_row b pos) (analize_row c pos)))]
                        (cond
                          (and (= current \#) (or (< cells 3) (> cells 4))) (recur (inc pos) (str res \ ))
                          (and (= current \ ) (= cells 3)) (recur (inc pos) (str res \#))
                          :else (recur (inc pos) (str res current)))))))
        new_board (concat [""] (conj board ""))]
    (map get_row (partition 3 1 new_board))))