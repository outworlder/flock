(use awful)
(use regex-literals)
(use srfi-1)

;; Fields is a alist of fields and the required validations.
;; Fields are taken from the request variables and matched.
;; A validation is a function.
;; IF - Aditional predicate
;; Message - Custom validation message
;; Returns true or error string
(define (with-validations fields #!key if)
  #f)

;; TODO: Add forms to execute for when the validation passes and for when validation fails.
(define-syntax with-validations
  (syntax-rules ()
    ([_ ((field (validation params ...) ...) ...) ] (begin
                                                      (let ([validation-results
                                                             (list
                                                              (let ([field-value ($ 'field #f)])
                                                                (++
                                                                 (let ([validation-result 
                                                                        (validation field-value params ...)])
                                                                   (if (string? validation-result) ;Validation failed
                                                                       validation-result)) ...)) ...)])
                                                        (if (> (length (filter string? validation-results)) 0)
                                                            validation-results ;Validation failed
                                                            #t))))))

 
;; Each validation function takes exactly one param
(define (validate-presence value #!key (message "teste"))
  (if (string? value)
      #t
      message))

(define (set-flash key value)
  ($session-set 'flash (key . value)))

(define (flash #!optional key)
  (let ([flash-data ($session 'flash)])
    (if key
        (assoc key flash-data)
        flash-data)))


;; Example:

;; (with-validations
;;  (age (validates-presence)
;;       (validates-numericality))
;;  (email (validates-presence)
;;         (validates-length maximum: 20)
;;         (validates-format "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}" message: "Email address should be in the format someone@domain.com")))


(define (validates-presence field #!key if message)
  #f)

(define (validates-confirmation field1 field2)
  #f)

(define (validates-format field regexp)
  #f)

(define (validates-length field #!key minimum maximum is)
  #f)

(define (validates-numericality field)
  #f)

