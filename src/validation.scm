(use awful)
(use srfi-1)

(define-syntax run-validations
  (syntax-rules ()
    ([_ success fail (validation ...)] (let ([validation-results (list validation ...)])
                          (if (every (lambda (x)
                                       (eq? x #t)) validation-results)
                              ;; Validation successful
                              (success)
                              (fail (filter (lambda (x)
                                              (not (eq? x #t))) validation-results)))))
    ([_ fail (validation ...)] (_ (lambda () #t) (validation ...)))))

(define (validate-presence k-v #!key (message " is required"))
  (let validation ([key-value k-v])
    (let ([key (car key-value)]
          [value (cdr key-value)])
      (if (and (string? value) (>= (string-length value) 0))
          #t
          (string-append (->string key) " " message)))
    (if (list? key-value)
        (map validation key-value)
        (validation key-value))))

(define (validates-confirmation key-value1 key-value2 #!key message)
  #f)

(define (validates-format field regexp)
  #f)

(define (validates-length field #!key minimum maximum is)
  #f)

(define (validates-numericality field)
  #f)

