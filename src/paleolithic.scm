(define (paleolithic #!rest args)
  `((div (@ (class "header"))
          (h1
           "Paleolithic Computing")
          (h2 "Because Computer Science is still in the stone age..."))
     (div (@ (class "site_content"))
     ,(render-blog-posts))))

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

(define (render-comment post)
  '(div (@ (class "comments")) (span "Comments") (p "No comments have been posted yet.")))

;; (send-cgi-response (html-body "Paleolithic Computing / Blog"  index
;;                               (stylesheet-link "/paleolithic.css")))

;; (define-page "Paleolithic Computing / Blog" (stylesheet-link "/paleolithic.css")
;;   index)
