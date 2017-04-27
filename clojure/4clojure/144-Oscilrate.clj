(fn t1 [value & funcs]
  (cons value (lazy-seq (apply t1 ((first funcs) value) (concat (rest funcs) [(first funcs)])))))