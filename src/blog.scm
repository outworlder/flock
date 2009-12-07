;; TODO: Use the module system and replace with (use)
(include "flock")

(include "paleolithic")
(include "post")
(include "comment_posted")
(include "blog_model")

(define-app paleolithic
  '(paleolithic post comment-posted))

(process-cgi)