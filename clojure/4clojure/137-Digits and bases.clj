(fn t8 [number base]
  (if (< number base)
    [ number ]
    (conj (t8 (int (/ number base)) base) (rem number base))))