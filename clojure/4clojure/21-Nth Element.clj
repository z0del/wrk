(fn value-at [my-list my-index]
  (if (zero? my-index) 
    (first my-list) 
    (recur (rest my-list) (dec my-index))))