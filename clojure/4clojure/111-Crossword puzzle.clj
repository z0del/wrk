(fn crosswords [word c]
  (let [cross (map (fn [row] (filter #(not= % \ ) row)) c) 
        transpose (apply map list cross)
        fit_word  (fn [word row]
                    (loop [w word r row]
                      (let [c1 (first w) c2 (first r)]
                        (cond
                          (empty? w) (if (or (empty? r) (= (first r) \#)) true false)
                          (empty? r) false
                          (or (= c1 c2) (= c2 \_)) (recur (rest w) (rest r))
                          (= c2 \#) (recur word (rest r))
                          :else false))))
        fit_rows (some true? (map #(fit_word word %) cross))
        fit_columns (some true? (map #(fit_word word %) transpose))]
    (or fit_rows fit_columns false)))