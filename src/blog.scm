(use spiffy awful intarweb html-tags sql-de-lite spiffy-request-vars)
(include "src/config")
(include "src/db")
(include "src/validation")
(include "src/blog_model")
(include "src/user_model")
(include "src/comment_model")
(include "src/authentication")
(include "src/helper")
(include "src/comment")
(include "src/admin")
(include "src/user_admin")
(include "src/flash")

;; TODO: Add a sort of "include dependencies"

(define (main-template contents #!key css title (doctype "") (headers "") charset)
  (html-page
   (++ 
    (<div> class: "header"
           (<div> class: "site_title"
                  (<h1>
                   (link (main-page-path) "Paleolithic Computing" class: "header_link"))
                  (<h2> "Because Computer Science is still in the stone age...")))
    (<div> id: "site_content"
           (if (has-flash 'notice)
               (<div> id: "notice"
                      (flash 'notice))
               "")
           (if (has-flash 'error)
               (<div> id: "error"
                      (flash 'error))
               "")
           (if contents contents ""))) css: css title: title doctype: doctype headers: headers charset: charset))

(page-template main-template no-session: #t)

(include "src/post")

(define (render-blog-posts #!optional (post-id #f))
  (let ([post-function
         (lambda (post)
           (<div> class: "post"
                  (<div> class: "post_header"
                         (<span> class: "title"
                                 (link "/post" 
                                       (slot-value post 'title) arguments: `((post_id . ,(slot-value post 'id)))))
                         (<span> class: "date"
                                 "Posted: " (seconds->string (slot-value post 'publishdate)))
                         (<div> class: "content"
                                (slot-value post 'content)
                                (if post-id
                                    (render-comment (slot-value post 'id))
                                    ""))
                         (<div> class: "post_footer"))))])
    (if post-id
        (post-function post-id)
        (map-web
         post-function
         (get-blog-posts)))))

(define-page (main-page-path)
  (lambda ()
    (render-blog-posts)))

(define-page "/post"
  (lambda ()
    (debug "Post-id: " ($ 'post_id))
    (let ([blog-post (get-blog-post-by-id ($ 'post_id))]) 
      (if blog-post
          (begin
            (if (eq? 'POST (request-method (current-request)))
                (with-request-vars* $ (post_id Name Email Url comment_area)
                                   (debug Name Email Url comment_area)
                                   (if (add-comment (make-comment #f Name Email Url post_id comment_area))
                                       (set-flash 'notice "Comment added successfully.")
                                       (set-flash 'error "Error adding comment."))))
            (render-blog-posts blog-post))
          (<h3> "Post not found.")))))

(define-page (login-page-path)
  (lambda ()
    (html-page 
     (<div> id: "login_prompt"
            (<div> class: "login_title" "Enter your login")
            (<div> class: "login_form"
                   (login-form))) css: "/assets/stylesheets/login.css")) no-session: #t no-template: #t)
