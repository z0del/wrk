(fn [f coll]
  (set (for [[key value] (group-by f coll)]
    (set value))))