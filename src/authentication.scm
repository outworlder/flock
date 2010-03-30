(use md5)
(use sql-de-lite)
(use awful)

(define (check-password login pass)
  (let ([hashed-password (md5-digest pass)])
    (if (null? (exec (sql (db-connection) "select * from authentication where login = ? and password = ?;") login hashed-password))
        #f
        #t)))

(define (with-hashed-password thunk pass)
  (let ([hashed-pass (md5-digest pass)])
    (thunk hashed-pass)))

(define (add-user login pass)
  (with-hashed-password
   (lambda (hash)
     (exec (sql (db-connection) "insert into authentication (login, password) values (?, ?);" login hash))) pass))

(define (update-user-password login password new-password)
  (with-hashed-password
   (lambda (hash)
     (exec (sql (db-connection) "update authentication set password = ? where login = ?;" hash login))) password))

(define (fetch-all-users)
  (exec (sql (db-connection) "select id, login from authentication;")))

(valid-password? check-password)
