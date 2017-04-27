(fn t112 
  ([x coll] (t112 x coll []))
  ([x coll ans]
   (let [r (first coll)]
     (cond
       (sequential? r) (conj ans (t112 x (first coll) []))
       (or (empty? coll) (> r x)) ans
       :else (t112 (- x r) (rest coll) (conj ans r))))))