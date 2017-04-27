(fn t133 [relation]
  (loop [old_relations relation]
    (let [r (for [e1 old_relations
                  e2 old_relations
                  :when (not= e1 e2)
                  :when (= (second e1) (first e2))]
                  [(first e1) (second e2)])
          new_relations (clojure.set/union old_relations r)]
      (if (= new_relations old_relations)
        new_relations
        (recur new_relations)))))