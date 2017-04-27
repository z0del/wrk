(fn t116 [n]
  (let [is_prime (fn is_prime [x] (if (= x 2)
                           true
                           (every? #(not= 0 (rem x %)) (cons 2 (filter odd? (range 3 x))))))]
    (and (not= n 1) (not= n 2) (is_prime n) (= n (/ (+ (nth (filter is_prime (range n (+ n 1000))) 1) (nth (filter is_prime (range n 0 -1)) 1)) 2)))))