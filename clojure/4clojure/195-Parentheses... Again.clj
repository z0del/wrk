(fn parentheses 
  ([n] (parentheses n n))
  ([left right]
    (if (and (zero? left) (zero? right)) 
      #{""}
      (clojure.set/union
        (when (> left 0)
          (set (map #(str "(" % ) (parentheses (dec left) right))))
        (when (> right left)
          (set (map #(str ")" % ) (parentheses left (dec right)))))))))