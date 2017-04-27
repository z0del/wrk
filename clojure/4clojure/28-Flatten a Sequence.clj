(fn flt [coll]
  (let [l (first coll) r (next coll)]
    (concat 
      (if (sequential? l)
        (flt l)
        [l])
      (when (sequential? r)
        (flt r)))))