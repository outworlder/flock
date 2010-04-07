(define (db-exec statement #!key params (database (default-database)))
  (call-with-database (default-database)
                      (lambda (database)
                        (if params
                            (exec (sql database statement) params)
                            (exec (sql database statement))))))

(define (db-query procedure statement #!key params (database (default-database)))
  (call-with-database (default-database)
                      (lambda (database)
                        (if params
                            (query procedure (sql database statement) params)
                            (query procedure (sql database statement))))))
