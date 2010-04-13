(use spiffy awful html-tags sql-de-lite)
(use autoform)

(include "src/config")
(include "src/blog_model")
(include "src/user_model")
(include "src/comment_model")
(include "src/authentication")
(include "src/helper")
(include "src/comment")
(include "src/admin")
(include "src/user_admin")

;; TODO: Add a sort of "include dependencies"

(define (main-template page)
  (++ 
   (<div> class: "header"
          (<h1> "Paleolithic Computing")
          (<h2> "Because Computer Science is still in the stone age..."))
   (<div> id: "site_content"
          (if page (page) ""))))

(include "src/post")

(define-page (main-page-path)
  (lambda ()
    (main-template render-blog-posts)))

(define (render-blog-posts)
  (map-web
   (lambda (post)
     (<div> class: "post"
            (<div> class: "post_header"
                   (<span> class: "title"
                           (blog-post-title post))
                   (<span> class: "date"
                           "Posted: " (seconds->string (blog-post-publish-date post)))
                   (<div> class: "content"
                          (blog-post-content post)
                          (render-comment (blog-post-id post)))
                   (<div> class: "post_footer")))) (get-blog-posts)))

;; (define (render-comment post)
;;   (<div> class: "comments" 
;;         (render-disqus-block)))

(define (render-disqus-block)
  (<div> id: "diqus_thread"
         (<script> type: "text/javascript" src: "http://disqus.com/forums/paleolithic-computing-blog/embed.js")))

(define-page (login-page-path)
  (lambda ()
    (<div> id: "login_prompt"
           (<div> class: "login_title" "Enter your login")
           (<div> class: "login_form"
                  (login-form)))) no-session: #t css: "/assets/stylesheets/login.css")
