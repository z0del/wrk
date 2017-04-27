(fn t8 [f & args]
  (let [r (apply f args)]
    (loop [res r]
      (if (not (instance? clojure.lang.IFn res))
        res
        (recur (res))))))