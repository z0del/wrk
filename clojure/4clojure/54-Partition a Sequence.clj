(fn t3 [c coll]
    (loop [cnt c tmp [] sol [] cl coll]
      (if (or (seq cl) (= cnt 0))
        (if (= cnt 0)
          (recur c [] (conj sol tmp) cl)                                   
          (recur (dec cnt) (conj tmp (first cl)) sol (rest cl)))
        sol)))