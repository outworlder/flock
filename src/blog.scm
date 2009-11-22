(include "config.scm")
(include "dependencies.scm")
(include "widgets.scm")
(include "sql.scm")

(define-record blog-post id title content publish-date visible)
(define-record-printer blog-post        ;TODO: It is not respecting the output port
  (lambda (record port)
    (print "[BLOG POST]")
    (print "Title: " (blog-post-title record))
    (print "Publish date: " (blog-post-publish-date record))
    (print "Visible: " (blog-post-visible record))
    (print "Content: " (blog-post-content record))))

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
