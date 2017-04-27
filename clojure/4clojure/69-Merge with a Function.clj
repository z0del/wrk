(fn t2 [f & maps]
  (let [g #(into {} (for [[x y] %2]
                       (if (%1 x)
                         [x (f (%1 x) y)]
                         [x y])))]
    (reduce #(conj %1 (g %1 %2)) maps)))