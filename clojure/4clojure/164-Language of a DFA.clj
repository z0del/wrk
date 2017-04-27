(fn DFA [dfa]
  (let [apply_transition (fn [state]
                           (let [transitions ((dfa :transitions) state)
                                 k (keys transitions)
                                 v (vals transitions)]
                             (map vector k v)))
        generate_transitions (fn [state]
                               (loop [transitions (apply_transition (first state)) res []]
                                 (if (empty? transitions) res
                                   (recur (rest transitions) 
                                          (concat res [[(second (first transitions))
                                                        (conj (second state) (first (first transitions)))]])))))]
      (loop [counter 0 states [[(dfa :start) []]] solutions #{}]
        (let [successors (generate_transitions (first states))
              accepted_strings (map #(second %) (filter #((dfa :accepts) (first %)) successors))]
          (cond
            (or (= counter 300)
                (empty? states)) solutions
            (empty? successors) (recur (inc counter) (rest states) solutions)
            :else (recur (inc counter) (concat (rest states) (generate_transitions (first states))) (concat solutions (set (map #(apply str %) accepted_strings)))))))))