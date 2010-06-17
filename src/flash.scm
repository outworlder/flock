(use http-session)

(define (set-flash key value)
  (if (session-valid? (sid))
      ($session-set 'flash `(,key . ,value))))

(define (flash key)
  (if (session-valid? (sid))
      (let ([flash-data ($session 'flash)])
        (if flash-data
            (let ([flash-message (assoc key flash-data)])
              flash-message)
            "")
        "")))

(define (has-flash key)
  (if (session-valid? (sid))
      (let ([flash-data ($session 'flash)])
        (if (and flash-data (assoc key flash-data))
                #t
                #f))
      #f))
                   