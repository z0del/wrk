(fn sumall [coll]
  (if (empty? coll) 0
      (+ (sumall (rest coll)) (first coll))))