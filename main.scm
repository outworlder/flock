;; Flock framework

(require-extension defstruct)
(require-extension sxml-transforms)

(defstruct route base params)
(defstruct response type extra-headers body)
(defstruct request query_string path_info)
(defstruct fragment type body)

(define *views-alist*
  '())

;; (define (add-route route function)
;;   (let ((route (break-route-url url)))
;;     (set! *routes-tree* (append *routes-tree* route))))

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

(define (render-view name)
  (let ((view-data (assoc name *views-alist*)))
    (unless view-data
      (signal 'view-not-found))
    (SRV:send-reply (assoc name *views-alist*))))

(define (define-view name body)
  (set! *views-alist* (append *views-alist*
           (list name body))))

;; Receives a list(sxml) as input, returns html as output
(define (render-sxml body)
  (make-fragment
   type: 'html body: (SXML->HTML body)))

(define (render-text body)
  (make-fragment
   type: 'text body: body))

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
   
(define (render-response response)
  (unless (response? response)
    (signal 'invalid-response)
    (print-content-type (response-type response)))
    (render-view (response-body response)))

(define index
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

(define (main)
  (define-view 'index index)
  (render-response (make-response type: 'html body: 'index)))


(main)