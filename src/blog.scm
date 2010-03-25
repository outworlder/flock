(use spiffy awful html-tags sql-de-lite)

(include "src/config")
(include "src/blog_model")
(include "src/authentication")

(define (main-template page)
  (++ 
   (<div> class: "header"
          (<h1> "Paleolithic Computing")
          (<h2> "Because Computer Science is still in the stone age..."))
   (<div> class: "content"
          (if page (page) ""))))
  
(define-page (main-page-path)
  (lambda ()
    (main-template render-blog-posts)))

(define (render-blog-posts)
  (apply ++
    (map (lambda (post)
           (<div> class: "post"
           (<div> class: "post_header"
                  (<span> class: "title"
                          (blog-post-title post))
                  (<span> class: "date"
                          "Posted: " (seconds->string (blog-post-publish-date post)))
                  (<div> class: "content"
                         (blog-post-content post)
                         (render-comment post))
                  (<div> class: "post_footer")))) (get-blog-posts))))

(define (render-comment post)
  (<div> class: "comments" 
        (render-disqus-block)))

(define (render-disqus-block)
  (<div> id: "diqus_thread"
         (<script> type: "text/javascript" src: "http://disqus.com/forums/paleolithic-computing-blog/embed.js")))

(define-page (login-page-path)
  (lambda ()
    (login-form))
  no-session: #t)
