(fn value-count [my-list]
  (if (= my-list '()) 0
      (+ (value-count (rest my-list)) 1)))