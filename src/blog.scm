(use flock)
(use sql-de-lite)

(include "paleolithic")
(include "post")
(include "comment_posted")
(include "blog_model")

(define-app paleolithic
  '(paleolithic post comment-posted))

(process-cgi)