(require '[clojure.string :refer [split]])

(def n (read-string (read-line)))
(def lst (map read-string (split (read-line) #" ")))

(def pos-n (count (filter (partial < 0) lst)))
(def neg-n (count (filter (partial > 0) lst)))
(def zero-n (reduce - n [pos-n neg-n]))

(println (format "%.3f" (/ (double pos-n) n)))
(println (format "%.3f"  (/ (double neg-n) n)))
(println (format "%.3f"  (/ (double zero-n) n)))
