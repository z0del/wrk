(fn t1 [coll] (not (reduce #(or %1 %2) (for [x coll
                                               y x                     
                                               z (disj coll x)]
                                            (contains? z y)))))