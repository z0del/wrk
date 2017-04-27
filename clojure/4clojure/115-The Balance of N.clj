(fn t8 [z]
  (letfn [(decompose_numbers [n] 
            (if (< n 10)
              [n] 
              (conj (decompose_numbers (int (/ n 10))) (rem n 10))))]
    (let [s (decompose_numbers z)
          len (count s)
          is_even (zero? (rem len 2))]
      (if is_even
        (if (= (reduce + (take (int (/ len 2)) s))
               (reduce + (take-last (int (/ len 2)) s)))
          true
          false)
        (if (= (reduce + (take (int (/ (dec len) 2)) s))
               (reduce + (take-last (int (/ (dec len) 2)) s)))
          true
          false)))))