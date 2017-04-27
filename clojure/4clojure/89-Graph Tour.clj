(fn tour [graph]
  (let [nodes (set (flatten graph))
        incident_grades (map (fn [x] (reduce #(+ %1 (if (or (= x (first %2)) (= x (second %2))) 1 0)) 0
                                             graph)) nodes)
        odd_nodes_are_0_or_2 (let [odd_nodes (count (filter #(odd?  %) incident_grades))]
                               (or (= 0 odd_nodes) (= 2 odd_nodes)))
        is_connected_a_graph? (loop [current [(first graph)] r (rest graph)]
                                (let [a (first (first r)) 
                                      b (second (first r))
                                      connection (some #(or (= (first %) a) (= (second %) a)
                                                            (= (first %) b) (= (second %) b)) current)]
                                  (cond 
                                    (empty? r) true
                                    (not connection) false
                                    :else (recur (conj current (first r)) (rest r)))))]
    (and is_connected_a_graph? odd_nodes_are_0_or_2)))