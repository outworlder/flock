(include "src/db")

(define-record blog-post id title content publish-date visible)
(define-record-printer blog-post        ;TODO: It is not respecting the output port
  (lambda (record port)
    (print "[BLOG POST]")
    (print "Title: " (blog-post-title record))
    (print "Publish date: " (blog-post-publish-date record))
    (print "Visible: " (blog-post-visible record))
    (print "Content: " (blog-post-content record))))

(define (make-blog-post-from-record record)
  (apply make-blog-post record))

(define (add-blog-post title content #!key (visible SQL-FALSE))
  (db-exec "insert into posts (content, publishdate, title, visible) values (?, ?, ?, ?);" content (current-seconds) title visible))

(define (get-blog-posts)
  (db-query (map-rows make-blog-post-from-record) "select id, title, content, publishdate, visible from posts order by publishdate DESC"))

(define (get-latest-blog-post)
  (make-blog-post-from-record (db-query fetch "select id, title, content, publishdate, visible from posts order by publishdate DESC limit 1")))
