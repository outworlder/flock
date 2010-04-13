(use awful)

;; TODO: Need to come up with a solution for XSS vulnerabilities.
(define (render-comment post-id)
  (let ([comments (get-comments-by-post-id post-id)])
    (if (null? comments)
        (<div> class: "comments"
               (<span>
                "No comments have been posted yet."))
        (map-web
         (<div> class: "comments"
                (<span> class: "comment_author"
                        (comment-author comment))
                (<span> class: "comment_email"
                        (comment-email comment))
                (<span> class: "comment"
                        (comment-comment comment))) comments))))

(define (render-comment-form)
  (++
   (<div> class: "comment_form"
          (<span> class: "author_box"
                  (text-input "Name:"))
          (<span> class: "email_box"
                  (text-input "Email:"))
          (<span> class: "Comment"
                  (textarea id: "comment_area"))
          (submit-input value: "Post comment")
          (<input> type: "reset" id: "reset_button"))))

                  