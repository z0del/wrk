(fn t5 [coll]
  (let [f (first coll) r (next coll)]
      (concat (if (sequential? f)
                (t5 f)
                [(flatten coll)])
            (when (and (sequential? r) (sequential? f))
              (t5 r)))))