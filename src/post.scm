(define (make-form-post)
  `((div (@ (class "content"))
         (form (@ (method post) (action "comment_posted"))
            ,(textfield 'title "Title" 'textbox)
            (br)
            (br)
            (textarea (@ (cols 80) (rows 10) (id post_message)))
            (br)
            (br)
            (input (@ (type submit) (value "Submit")))
            (input (@ (type reset) (value "Clear")))))))

(define (post #!rest args)
  (define-page "Post a new comment"
    (stylesheet-link "/paleolithic.css")
    (lambda ()
      `((div (@ (class "header"))
             (h1 "New blog post")
             (h2 "Lambda"))
        (br)
        ,(make-form-post)))))

;; (send-cgi-response
;;  (html-body "Post a new comment" post-view
;;             (stylesheet-link "/paleolithic.css")))