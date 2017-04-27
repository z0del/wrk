(fn P96 
  ([t] (P96 (nth t 1) (nth t 2) ))
  ([t1 t2]
  (if (and (= t1 nil) (= t2 nil))
    true
    (if (= (first t1) (first t2))
      (and (P96 (nth t1 1) (nth t2 2)) (P96 (nth t1 2) (nth t2 1)))
      false))))