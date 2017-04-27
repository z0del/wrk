(fn t2 [n]
  (letfn [(decompose_numbers [n]
           (if (< n 10)
                [n]
                (conj (decompose_numbers (int (/ n 10))) (rem n 10))))]
    (loop [n (reduce + (map #(* %1 %1) (decompose_numbers n)))  c 0]
      (cond     
        (= n 1) true
        (= c 1000) false
        :else
         (recur
          (reduce + (map #(* %1 %1) (decompose_numbers n))) (inc c))))))