(fn reparenting [node tree]
  (letfn [(find-subtree [tree]
                        (let [root (nth tree 0 nil)
                              left (nth tree 1 nil)
                              right (nth tree 2 nil)]
                          (cond
                            (nil? root) nil
                            (= root node) tree
                            :else (or (find-subtree left)
                                      (find-subtree right)))))
          (get-parent [[root left right]]
                      (cond
                        (or (nil? root) (= node (first left)) (= node (first right))) root
                        :else (or (get-parent left) (get-parent right))))
          (get-parent-tree [node [root & children]]
                           (if (nil? root) 
                             nil
                             (concat (list root) (for [child children :when (not= node (first child))] (get-parent-tree node child)))))]
    (let [p (get-parent tree)
          q (get-parent-tree node tree)
          t (find-subtree tree)]
      (if (nil? p) tree
        (concat t (list (reparenting p q)) )))))