(use spiffy awful html-tags sql-de-lite)

;; (include "paleolithic")
;; (include "post")
;; (include "comment_posted")
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
  (let ([posts (get-blog-posts)])
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
                  (<div> class: "post_footer")))) posts)))

(define (render-comment post)
  "")

