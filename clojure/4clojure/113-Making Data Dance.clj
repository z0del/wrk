(fn data-dance [& coll]
  (reify Object
       (toString [this] (apply str (interpose ", " (sort coll))))
    clojure.lang.Seqable
       (seq [this] (if (empty? coll) nil (distinct coll)))))