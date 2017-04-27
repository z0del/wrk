(fn compare [lt a b]
  (if (lt a b) 
    :lt
    (if (lt b a) 
      :gt
      :eq)))