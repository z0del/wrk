(fn t4 [n]
  (if (= n 1) 1
  (let [gcd #(let [x (max %1 %2)
                   y (min %1 %2)]
               (if (zero? y)
                 x
                 (recur y (rem x y))))
        coprime_with_n? #(= (gcd %1 n) 1)]
    (count (filter coprime_with_n? (range 1 n))))))