(fn lcm3
  ([x y]
     (letfn [(gcd2 [a b]
               (cond
                (= b 0) a
                (> a b) (gcd2 b (mod a b))
                (> b a) (gcd2 a (mod b a))))]
       (/ (* x y) (gcd2 x y))))
  ([x y & rest] (apply lcm3 (lcm3 x y) rest)))