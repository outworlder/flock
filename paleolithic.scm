(use sxml-transforms)
(use uri-common)
(use doctype)
(use sql-de-lite)
(use posix)                             ;Posix date and time manipulation

(define *database* "/home/stephen/projects/git/flock/paleolithic.sqlite") ;TODO: Absolute paths suck!

(define-record blog-post id title content publish-date visible)
(define-record-printer blog-post        ;TODO: It is not respecting the output port
  (lambda (record port)
    (print "[BLOG POST]")
    (print "Title: " (blog-post-title record))
    (print "Publish date: " (blog-post-publish-date record))
    (print "Visible: " (blog-post-visible record))
    (print "Content: " (blog-post-content record))))

(define (send-cgi-response page)
  (print "Content-type: text/html")
  (print)
  (print xhtml-1.0-strict)
  (SXML->HTML (page))
  (print))

(define (stylesheet-link href #!key (media 'screen))
  `(link (@ (rel "stylesheet") (type "text/css") (media ,media) (href ,href))))

(define (index #!rest args)
  `(html
    (head 
     (title "Paleolithic Computing / Blog")
     ,(stylesheet-link "/paleolithic.css"))
    (body
     (div (@ (class "header"))
          (h1
           "Paleolithic Computing")
          (h2 "Because Computer Science is still in the stone age..."))
     (div (@ (class "site_content"))
     ,(render-blog-posts)))))

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
                 (div (@ (class "comments")) (span "Comments") (p "No comments have been posted yet."))
                 (div (@ (class "post_footer"))))) posts)))

(define (make-blog-post-from-record record)
  (apply make-blog-post record))
   
(define (get-latest-blog-post)
  (call-with-database *database*
                      (lambda (database)
                        (make-blog-post-from-record (query fetch  (sql database "select id, title, content, publishdate, visible from posts order by publishdate DESC limit 1"))))))

(define (get-blog-posts)
  (call-with-database *database*
                      (lambda (database)
                        (query (map-rows make-blog-post-from-record) (sql database "select id, title, content, publishdate, visible from posts order by publishdate DESC")))))

(define SQL-TRUE 1)

(define SQL-FALSE 0)

(define (add-blog-post title content #!key (visible SQL-FALSE))
  (call-with-database *database*
                      (lambda (database)
                        (exec (sql database "insert into posts (content, publishdate, title, visible) values (?, ?, ?, ?);") content (current-seconds) title visible))))
(send-cgi-response index)
