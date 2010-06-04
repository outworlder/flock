(use uri-common)
(use md5)

;; Gravatar integration

(define gravatar-uri (make-parameter "http://www.gravatar.com/avatar"))

(define (make-gravatar-url email-address #!key size rating default)
  (let ([hashed-mail (md5-digest (string-delete #\space email-address))])
    (string-append (gravatar-uri) "/" hashed-mail)))