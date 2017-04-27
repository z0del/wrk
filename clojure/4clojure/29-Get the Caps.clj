(fn [coll]
  (apply str (filter #(Character/isUpperCase %) coll)))