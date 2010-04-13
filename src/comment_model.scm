(define-record comment id author email post_id comment)

(define-record-printer comment
  (lambda (record port)
    (print "[COMMENT]: " )
    (print "ID: " (comment-id record))
    (print "Author: " (comment-author record))
    (print "Email: " (comment-email record))
    (print "Comment: " (comment-comment record))))

(define (make-comment-from-record)
  (apply make-comment record))

(define (add-comment comment)
  (db-exec (insert comments (author email post_id comment) (? ? ? ?)) (comment-author comment) (comment-email comment) (comment-post_id comment) (comment-comment)))

(define (remove-comment comment)
  (db-exec (delete comments (where (= id (comment-id))))))

(define (get-comments)
  (db-query (map-rows make-comment-from-record) (from comments (id author email post_id comment))))

(define (get-comment-by-post-id post_id)
  (db-query fetch (from comments (id author email post_id comment) (where (= post_id post_id)))))