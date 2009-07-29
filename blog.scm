;; This defines the blog pages. It is mostly used to test the framework.

(make-application 'scheme-blog-app "/blog")

(define (main)
  (print "Content-type: text/html\n\n")
  (print "Hello world from hell!"))

;; TODO: Declare this as render-view
(define-widget-view 'scheme-blog-app 'index
  `(html
   (head
    (title "Stone-age blog")
    (stylesheet "stone-age.css"))
   (body
    ,(render-blog-post))))

(define (render-blog-post)
  '((h1
   "Oh look, I'm a blog post")
   (hr)
   (div "Pretend this shit came from a database")))

(define (index)
  (render-view 'index))
