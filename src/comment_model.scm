(use coops)
(use orly)

(define-model <blog-comment> "comments"
  (id author email url post_id comment))

(define-syntax validate-comment
  (syntax-rules ()
    ([_ (comment) body ... ] (run-validations
                              (lambda ()
                                body ...)
                              (lambda (results)
                                (string-append results))
                              ((validate-presence `(author . ,(slot-value comment 'author)))
                               (validate-presence `(email  .,(slot-value comment 'email)))
                               (validate-presence `(comment . ,(slot-value comment 'comment))))))))

(define (add-comment comment)
  (validate-comment (comment)
                    (debug comment)
                    (db-exec (insert comments (author email url post_id comment) (? ? ? ? ?)) (comment-author comment) (comment-email comment) (comment-url comment) (comment-post_id comment) (comment-comment))))

(define (remove-comment comment)
  (db-exec (delete comments (where (= id (comment-id))))))

(define (get-comments)
  (find-all <blog-comment>))

(define (get-comments-by-post-id post-id)
  (comments (find-by-id <blog-post> post-id)))
