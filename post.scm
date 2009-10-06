(include "blog.scm")

;; Field is in the form '(name type)

(define (make-form-post)
  `(form (@ (method post) (url "comment_posted"))
         ,(textfield 'title "Title" 'textbox)
         (br)
         (br)
         (textarea (@ (cols 80) (rows 10) (id post_message)))
         (br)
         (br)
         (input (@ (type submit) (value "Submit")))
         (input (@ (type reset) (value "Clear")))))

(define (post-view)
  `((h1
     "New blog post")
    (hr)
    (br)
    ,(make-form-post)))

(send-cgi-response
 (html-body "Post a new comment" post-view
            (stylesheet-link "/paleolithic.css")))