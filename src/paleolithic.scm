(define-page paleolithic "Paleolithic Computing / Blog"
  `(,(stylesheet-link "/paleolithic.css")
    ,(javascript-link "/disqus_params.js"))
      `((div (@ (class "header"))
             (h1
              "Paleolithic Computing")
             (h2 "Because Computer Science is still in the stone age..."))
        (div (@ (class "site_content"))
             ,(render-blog-posts))
        ,(render-disqus-script)))

(define (render-blog-posts)
  (let ([posts (get-blog-posts)])
    (map (lambda (post)
           `(div (@ (class "post"))
                 (div (@ (class "post_header"))
                      (span (@ (class "title"))
                            ,(blog-post-title post))
                      (span (@ (class "date"))
                            "Posted: " ,(seconds->string (blog-post-publish-date post))))
                 (div (@ (class "content")) ,(blog-post-content post))
                 ,(render-comment post)
                 (div (@ (class "post_footer"))))) posts)))

;; (define (render-comment post)
;;   '(div (@ (class "comments")) (span "Comments") (p "No comments have been posted yet.")))

(define (render-comment post)
  `(div (@ (class "comments")) 
        ,(render-disqus-block)))

(define (render-disqus-block)
  '((div (@ (id "diqus_thread")))
    (script (@ (type "text/javascript") (src "http://disqus.com/forums/paleolithic-computing-blog/embed.js")))
    (noscript
     (a (@ (href "http://disqus.com") (class "dsq-brl
ink")) "Blog comments powered by "
        (span (@ (class "logo-disqus")) "Disqus")))))

(define (render-disqus-script)
  (javascript-link "/disqus.js"))
