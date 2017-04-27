(fn P97 [n]
  (loop [count n c 1 Vc 1 result [1]]
    (if (= count 1)
      result
      (recur (dec count) (inc c) (* Vc (/ (- n c) c)) (conj result (int (* Vc (/ (- n c) c))))))))