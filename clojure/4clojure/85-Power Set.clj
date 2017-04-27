(fn t6 [coll]
  (letfn [(combs [n]
            (if (zero? n)
              [[]]
              (for [smaller (combs (dec n))
                    b [true false]]
                (cons b smaller))))
          (filter_vector [coll1 coll2]
            (for [[value pos] (map vector coll2 (range))
                  :when (nth coll1 pos)]
              value))]
    (set (for [l (combs (count coll))]
      (set (filter_vector l coll))))))