(fn maze 
    ([n1 n2] (maze n2 [[n1] 1] []))
    ([goal current frontier]
      (let [[f, x] current
            temp_frontier (map #(if (even? %)
                                  [(+ % 2) (* % 2) (/ % 2)]
                                  [(+ % 2) (* % 2)]) f)
            new_frontier (concat frontier (map #(vector % (inc x)) temp_frontier))]
        (if (reduce #(or %1 %2) (map #(= % goal) f))
          x
          (recur goal (first new_frontier) (rest new_frontier))))))