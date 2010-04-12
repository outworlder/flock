(use aql)

(define-record user id login password)
(define-record-printer user
  (lambda (record port)
    (print "[USER]")
    (print "ID: " (user-id record))
    (print "Login: " (user-login record))
    (print "Password(hash): " (user-password record))))

(define (make-user-from-record record)
  (apply make-user record))

(define (add-user user)
  (db-exec (insert authentication (login password) (? ?)) (user-login user) (user-password user)))

(define (remove-user user)
  (db-exec (delete authentication (where (= id ?))) (user-id user)))

(define (update-user user)
  (db-exec (update user ((login ?) (password ?)) (where (= id ?))) (user-login user) (user-password user) (user-id user)))

(define (get-user #!optional user)
  (if user
      (db-query (map-rows make-user-from-record) (from user (id login password)))
      (db-query make-user-from-record (from user (id login password) (where (= id ?))) user)))