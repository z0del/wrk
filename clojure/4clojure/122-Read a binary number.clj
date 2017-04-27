(fn P122 [ num ]
  (loop [n num result 0 cont (dec (count num))]
    (if (= cont 0)
      (if (= (first n) \1)
        (int (inc result))
        (int result))
      (if (= (first n) \1)
        (recur (rest n) (+ result (Math/pow 2 cont)) (dec cont))
        (recur (rest n) result (dec cont))))))