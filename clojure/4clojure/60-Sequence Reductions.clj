(fn t1
  ([f coll]
     (t1 f (first coll) (next coll)))
  ([f v coll]
     (if (= coll nil)
       (cons v nil)
       (let [n (f v (first coll))]
         (lazy-seq
          (cons v (t1 f n (next coll))))))))