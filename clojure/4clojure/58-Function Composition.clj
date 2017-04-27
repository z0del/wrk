(fn t1 [& funcs]
  (fn [& args]
    (loop [f (reverse funcs) data args]
      (if (seq f)
            (recur (rest f) (list (apply (first f) data)))
        (first data)))))