;; Miscelaneous helper functions. Kinda like Rails

;; Executes thunk (which should return a string) for every item in list. Returns a concatenated string with the result of all function applications.
(define (map-web thunk list)
  (apply ++
         (map (lambda (item)
                (thunk item)) list)))