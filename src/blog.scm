(include "config.scm")
(include "dependencies.scm")
(include "widgets.scm")
(include "sql.scm")
(include "paleolithic.scm")
(include "post.scm")
(include "comment_posted.scm")
(include "blog_model.scm")

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

;; Obtains the full request URI
;; TODO: It is broken. Should strip the server version from SERVER_PROTOCOL
(define (request-uri)
  (map (lambda (x)
         (getenv x))
         '("SERVER_PROTOCOL"
          "SERVER_PORT"
          "PATH_INFO")))


(dispatch-uri (uri-reference (getenv "PATH_INFO")))