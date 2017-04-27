(fn t117 [ string ]
  (loop [s string st '()]
    (let [c (first s)]
      (cond
        (empty? s) (empty? st)
        (or (= c \{)  (= c \()  (= c \[)) (recur (rest s) (conj st c))
        (= c \}) (if (= (first st) \{)
                   (recur (rest s) (rest st))
                   false)
        (= c \)) (if (= (first st) \()
                   (recur (rest s) (rest st))
                   false)
        (= c \]) (if (= (first st) \[)
                   (recur (rest s) (rest st))
                   false)
        :else (recur (rest s) st)))))