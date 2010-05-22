(use awful)
(use html-utils)

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
                        (comment-comment comment))) comments))
    (render-comment-form post-id)))

(define (render-comment-form post-id)
  (++
   (form 
    (<div> class: "comment_form"
           (<fieldset>
            (<legend> "Post a comment")
            (<span> class: "author_box"
                    (<label> for: "author_name" "Name: ")
                    (text-input "Name:" id: "author_name"))
            (<span> class: "email_box"
                    (<label> for: "author_email" "Email: ")
                    (text-input "Email:" id: "author_email"))
            (<span> class: "Comment"
                    (<textarea> id: "comment_area"))
            (<span> class: "buttons"
                    (submit-input value: "Post comment")
                    (<input> type: "reset" id: "reset_button")
                    (<input> type: "hidden" id: "post-id" value: post-id))))
           action: "post_comment" method: 'post)))

                  