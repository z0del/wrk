(fn t158 [c]
  (fn [& values]
    (loop [res (c (first values)) v (rest values)]
      (if (empty? v)
        res
        (recur (res (first v)) (rest v))))))