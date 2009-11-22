(include "blog.scm")

(define (comment-posted-view)
  `((div (@ (class "header"))
         (h1 "Post a new comment")
         (h2 "Comment posted successfully..."))
    (h1 "Result" (div ,(handle-post)))))

(send-cgi-response (html-body "Comment posted" comment-posted-view
                              (stylesheet-link "/paleolithic.css")))