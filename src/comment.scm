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
           (<legend> "Post a comment")
           (<hr>)
           (<input> type: "hidden" name: "post_id" value: post-id)
            (<span> class: "author_box"
                    (<p>
                     (<label> for: "author_name" "Name ")
                     (text-input "Name" id: "author_name" name: "author_name")))
            (<span> class: "email_box"
                    (<p>
                     (<label> for: "author_email" "Email ")
                     (text-input "Email" id: "author_email" name: "author_email")))
            (<span> class: "url_box"
                    (<p>
                     (<label> for: "author_url" "Url ")
                     (text-input "Url" id: "author_url" name: "author_url")))
            (<span> class: "Comment"
                    (<textarea> id: "comment_area" name: "comment_area"))
            (<span> class: "buttons"
                    (submit-input value: "Submit comment")
                    ;; (<input> type: "reset" id: "reset_button")
                    (<input> type: "hidden" id: "post-id" value: post-id)))
           action: (string-append "/post?postid=" (->string post-id) ";" (sid)) method: 'post)))

                  