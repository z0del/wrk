(fn t1 [value m]
  (if (contains? m value)
          (if (= (get m value) nil) 
            true 
            false)
          false))