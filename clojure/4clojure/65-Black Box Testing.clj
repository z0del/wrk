(fn t8 [x]
  (if (associative? x)
    (if (reversible? x)
      :vector
      :map)
    (if (contains? (conj x :decoy) :decoy)
      :set
      :list)))