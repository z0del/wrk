(fn [n] (let [is_prime (fn [x] (if (= x 2) 
                                      true
                                      (every? #(not= 0 (rem x %)) (cons 2 (filter odd? (range 3 x))))))]
             (take n (filter is_prime (iterate inc 2)))))