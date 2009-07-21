;; Flock framework

(require-extension uri-dispatch)
(require-extension defstruct)

(define routes-tree
  '())

(defstruct response type extra-headers body)
(defstruct request query_string path_info)

(define cgi-environment-variables-list
   '("SERVER_SOFTWARE"
  "SERVER_NAME"
 "GATEWAY_INTERFACE"
 "SERVER_PROTOCOL"
 "SERVER_PORT"
 "REQUEST_METHOD"
 "PATH_INFO"
 "PATH_TRANSLATED"
 "SCRIPT_NAME"
 "QUERY_STRING"
 "REMOTE_HOST"
 "REMOTE_ADDR"
 "AUTH_TYPE"
 "REMOTE_USER"
 "REMOTE_IDENT"
 "CONTENT_TYPE"
 "CONTENT_LENGTH"))

(define (get-env env-vars var)
  (cadr (assoc var env-vars)))

;; Returns an alist containing the CGI environment variables
(define (make-cgi-env-alist)
  (map
       (lambda (x)
	 (list x (get-environment-variable x)))  cgi-environment-variables-list))

(define (main)
  (print "Content-type: text/html\n\n")
  (print "Hello world from hell!"))

(define-view 'index
  (html
   (head
    (title "Stone-age blog")
    (stylesheet "stone-age.css"))
   (body
    (render-blog-post))))

(define (render-view name)
  ())

(define (handle-errors message)
  (print-content-type 'html)
  (print message))

(define (decide-content-type type)
  (case type
    ((html) "text/html")
    ((js) "application/javascript")
    ((css) "text/stylesheet")
    ((text) "text/plain")
    ((gif) "image/gif")
    ((jpeg) "image/jpeg")
    ((png) "image/png")
    ((xml) "text/xml")
    (else "application/octet-stream"))) ;TODO: Follow the RFC (http://www.w3.org/Protocols/rfc2616/rfc2616-sec7.html#sec7.2.1) to the letter and figure out what to do with unknown types

(define (print-content-type type)
  (print "Content-type: " (decide-content-type type))
  (print))
   
;; Headers is an association list, with the headers that are going into the response. If nil(or empty),
;; render a standard set of headers
(define (render-response response)
  (unless (response? response)
    (handle-errors "render-response: Asked to render something that's not a response object.")
    (print-content-type (response-type response))
    (display ((response-body response)))))

(define (index)
  (render-view 'index))

(main)