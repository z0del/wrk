(fn [s] (let [ss (clojure.string/split s #"-")]
               (apply str (cons (first ss) (map (fn [x] (str (.toUpperCase (subs x 0 1)) (subs x 1))) (rest ss))))))