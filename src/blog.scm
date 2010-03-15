(use spiffy awful html-tags sql-de-lite)

(include "src/config")
(include "src/blog_model")

(web-repl-access-control
 (lambda ()
   (member (remote-address) '("127.0.0.1"))))

(enable-web-repl "/repl")

(page-css "assets/stylesheets/paleolithic.css")

(debug-log (current-error-port))

(page-exception-message
	 (lambda (exn)
	   (<pre> convert-to-entities?: #t
	          (with-output-to-string
	            (lambda ()
	              (print-call-chain)
	              (print-error-message exn))))))

(define (default-database)
  *database*)

(define-page (main-page-path)
  (lambda ()
    (++ 
     (<div> class: "header"
            (<h1> "Paleolithic Computing")
            (<h2> "Because Computer Science is still in the stone age..."))
     (<div> class: "content"
            (render-blog-posts)))))

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

