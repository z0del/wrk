(fn t16 [p c coll]
  (if (empty? coll)
    coll
    (cons (first coll)
          (flatten (for [[x y] (partition 2 1 coll)]
                     (if (p x y)  
                       [c y]
                       [y]))))))