(fn P66 [x y] 
  (loop [a (max x y) b (min x y)]
    (if (= b 0)
      a
      (recur b (rem a b)))))