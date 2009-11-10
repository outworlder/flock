(include "config.scm")
(include "dependencies.scm")
(include "widgets.scm")

(define-record blog-post id title content publish-date visible)
(define-record-printer blog-post        ;TODO: It is not respecting the output port
  (lambda (record port)
    (print "[BLOG POST]")
    (print "Title: " (blog-post-title record))
    (print "Publish date: " (blog-post-publish-date record))
    (print "Visible: " (blog-post-visible record))
    (print "Content: " (blog-post-content record))))

(define (STANDARD-EXCEPTION-SCREEN exn)
  ((html-body "Error"
              (lambda ()
                `(div (@ (class "error_box"))
                      (span "An error has ocurred:")
                      (div (@ (class "error_text"))
                      ,((condition-property-accessor 'exn 'message) exn))))
              (stylesheet-link "/error.css"))))

(define (handle-error thunk #!optional [screen STANDARD-EXCEPTION-SCREEN])
  (handle-exceptions exn
   (screen exn)
   (thunk)))

(define (send-cgi-response page)
  (print "Content-type: text/html")
  (print)
  (print xhtml-1.0-strict)
  (SXML->HTML (handle-error page))
  (print))

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

(define (handle-form-post form-data-set)
  (form-urldecode form-data-set))

(define (handle-multipart-form-post form-data-set)
  (signal 'NOT-IMPLEMENTED))

(define *post-content-types*
  `(("application/x-www-form-urlencoded" ,handle-form-post)
    ("multipart/form-data" ,handle-multipart-form-post)))

;; Detects the encoding, then process it.
(define (handle-post)
  (let ([content-type (getenv "CONTENT_TYPE")]
        [content (list->string (raw-process-post))])
    (let ([procedure (assoc content-type *post-content-types*)])
      (if procedure
        ((cadr procedure) content)
        (signal 'UNKNOWN-POST-CONTENT-TYPE)))))

;; Gets raw data from the standard input.
(define (raw-process-post)
  (let ([content-length (getenv "CONTENT_LENGTH")])
    (if (not content-length)
      (signal 'ZERO-CONTENT-LENGTH)
      (with-input-from-port (current-input-port)
        (lambda ()
          (let loop ([x 0]
                     [x-max (string->number content-length)]
                     [current-data '()])
            (if (>= x x-max)
                current-data
                (begin
                  (loop (+ x 1) x-max (append current-data (list (read-char))))))))))))
