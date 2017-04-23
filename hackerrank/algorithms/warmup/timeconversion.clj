(require '[clojure.string :as str])

(defn tokenize-time [time-12]
  (re-seq #"\d+|AM|PM" time-12))

(defn convert-time [time-12]
  (let [[h m s xm] (tokenize-time time-12)
        hour (cond
              (= h "12") (if (= xm "AM") "00" "12")
              (= xm "PM")(str (+ 12 (Integer/parseInt h)))
              :else h)]
    (str/join ":" [hour m s])))

(defn interact [f]
  (let [in (slurp *in*)]
    (println (f in))))
    
