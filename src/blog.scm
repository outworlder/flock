(use spiffy awful html-tags sql-de-lite)

(include "src/config")
(include "src/db")
(include "src/blog_model")
(include "src/user_model")
(include "src/comment_model")
(include "src/authentication")
(include "src/helper")
(include "src/comment")
(include "src/admin")
(include "src/user_admin")

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
           (if contents contents ""))) css: css title: title doctype: doctype headers: headers charset: charset))

(page-template main-template)

(include "src/post")

(define (render-blog-posts #!optional (post-id #f))
  (let ([post-function
         (lambda (post)
           (<div> class: "post"
                  (<div> class: "post_header"
                         (<span> class: "title"
                                 (link "/post" 
                                       (blog-post-title post) arguments: `((postid . ,(blog-post-id post)))))
                         (<span> class: "date"
                                 "Posted: " (seconds->string (blog-post-publish-date post)))
                         (<div> class: "content"
                                (blog-post-content post)
                                (if post-id
                                    (render-comment (blog-post-id post))
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
    (let ([blog-post (get-blog-post-by-id ($ 'postid))])
         (if blog-post
             (render-blog-posts blog-post)
             (<h3> "Post not found.")))))

(define-page (login-page-path)
  (lambda ()
    (html-page 
     (<div> id: "login_prompt"
            (<div> class: "login_title" "Enter your login")
            (<div> class: "login_form"
                   (login-form))) css: "/assets/stylesheets/login.css")) no-session: #t no-template: #t)
