(let [n (Integer/parseInt (read-line))
      matrix (for [_ (range n)] (->> (clojure.string/split (read-line) #"\s+") (mapv #(Integer/parseInt %))))
      s1 (reduce + (for [i (range n)] (nth (nth matrix i) i)))
      s2 (reduce + (for [i (range n)] (nth (nth matrix i) (- n (inc i)))))]
  (println (Math/abs (- s1 s2))))
