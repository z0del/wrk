(fn [v coll]
  (let [len (count coll) s (cycle coll)]
    (if (pos? v)
      (take len (drop v s))
      (take len (drop (mod v len) s)))))