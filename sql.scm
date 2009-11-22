(define (get-latest-blog-post)
  (call-with-database *database*
                      (lambda (database)
                        (make-blog-post-from-record (query fetch  (sql database "select id, title, content, publishdate, visible from posts order by publishdate DESC limit 1"))))))

(define (get-blog-posts)
  (call-with-database *database*
                      (lambda (database)
                        (query (map-rows make-blog-post-from-record) (sql database "select id, title, content, publishdate, visible from posts order by publishdate DESC")))))

(define SQL-TRUE 1)

(define SQL-FALSE 0)

(define (add-blog-post title content #!key (visible SQL-FALSE))
  (call-with-database *database*
                      (lambda (database)
                        (exec (sql database "insert into posts (content, publishdate, title, visible) values (?, ?, ?, ?);") content (current-seconds) title visible))))