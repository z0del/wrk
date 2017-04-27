(fn t2 [& funcs]
  (fn [& args]
    (for [f funcs]
      (apply f args))))