(fn t1 [c1 c2]
  (let [x1 (for [x c1 :when (not (contains? c2 x))] x) x2 (for [x c2 :when (not (contains? c1 x))] x)]
    (set (concat x1 x2))))