(fn P95 [tree]
  (if (and (not= tree false) 
           (or (and (= (count tree) 3)
                    (P95 (nth tree 1))
                    (P95 (nth tree 2)))
               (= tree nil)))
    true
    false))