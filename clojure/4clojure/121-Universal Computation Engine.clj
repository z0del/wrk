(fn t121 [[op & operands]]
  (fn [data]
    (let [proceed (fn [x]
                    (cond
                      (number? x) x
                      (symbol? x) (data x)
                      :else ((t121 x) data)))
          o (map proceed operands)]
      (cond
        (= op '/) (apply / o)
        (= op '+) (apply + o)
        (= op '-) (apply - o)
        :else (apply * o)))))