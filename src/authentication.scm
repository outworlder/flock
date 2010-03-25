(use md5)
(use sql-de-lite)
(use awful)

(define (check-password login pass)
  (let ([hashed-password (md5-digest pass)])
    ;; TODO: Figure out a better way. exec can return a list. We are returning #t if it does.
    (if (exec (sql (db-connection) "select * from authentication where login = ? and password = ?;") login hashed-password)
        #t
        #f)))

(valid-password? check-password)
