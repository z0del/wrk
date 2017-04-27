(fn t125 [ roman ]
  (let [values {\I 1 \V 5 \X 10 \L 50
                \C 100 \D 500 \M 1000}
        sum_values (map (fn [[a b]] (if (< (values a) (values b)) (- (values a)) (values a))) (partition 2 1 roman))]
    (reduce + (values (last roman)) sum_values)))