(fn t148 [n a b]
  (let [x (bigint (quot (dec n) a))
        y (bigint(quot (dec n) b))
        mult_a_b (bigint (* a b))
        z (quot (dec n) mult_a_b)
        c (* (/ (* x (inc x)) 2) a)
        d (* (/ (* y (inc y)) 2) b)
        e (* (/ (* z (inc z)) 2) mult_a_b)]
    (- (+ c d) e)))