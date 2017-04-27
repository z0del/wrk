(fn t132 [triangle]
  (let [ update (fn [ans pos row]
                  [[(conj ans (nth row pos)) pos]
                   [(conj ans (nth row (+ 1 pos))) (+ 1 pos)]])]
  (loop [ answers [ [ (first triangle) 0 ] ] current (rest triangle) ]
    (if (empty? current) 
      (apply + (first (sort #(compare (apply + %1) (apply + %2)) (map first answers))))
      (let [new_answers (for [ans answers]
                          (update (first ans) (second ans) (first current)))]
        (recur (apply concat new_answers) (rest current)))))))