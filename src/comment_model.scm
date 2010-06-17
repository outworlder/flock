(define-record comment id author email url post_id comment)

(define-record-printer comment
  (lambda (record port)
    (print "[COMMENT]: " )
    (print "ID: " (comment-id record))
    (print "Author: " (comment-author record))
    (print "Email: " (comment-email record))
    (print "Comment: " (comment-comment record))))


(define-syntax validate-comment
  (syntax-rules ()
    ([_ (comment) body ... ] (run-validations
                              (lambda ()
                                body ...)
                              (lambda (results)
                                (string-append results))
                              ((validate-presence `(author . ,(comment-author comment)))
                               (validate-presence `(email  .,(comment-email comment)))
                               (validate-presence `(comment . ,(comment-comment comment))))))))

(define (make-comment-from-record record)
  (apply make-comment record))

(define (add-comment comment)
  (validate-comment (comment)
                    (debug comment)
                    (db-exec (insert comments (author email url post_id comment) (? ? ? ? ?)) (comment-author comment) (comment-email comment) (comment-url comment) (comment-post_id comment) (comment-comment))))

(define (remove-comment comment)
  (db-exec (delete comments (where (= id (comment-id))))))

(define (get-comments)
  (db-query (map-rows make-comment-from-record) (from comments (id author email url post_id comment))))

(define (get-comments-by-post-id post_id)
  (db-query (map-rows make-comment-from-record) (from comments (id author email url post_id comment) (where (= post_id post_id)))))
