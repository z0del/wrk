(fn fib 
  ([x] (fib (dec x) '(1) 0 1))
  ([x l a b]
    (if (= x 0) l
      (recur (dec x) (concat l (list (+ a b))) b (+ a b)))) 
  )