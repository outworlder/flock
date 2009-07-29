;; Flock framework

(require-extension defstruct)
(require-extension sxml-transforms)
(require-extension uri-common)

(defstruct route base params)
(defstruct response type extra-headers body)
(defstruct request uri)
(defstruct fragment type body)
(defstruct application-context name path session-store database-adapter widgets)
(defstruct widget name renderer content)

(define *views-alist
  '())

(define *applications-alist*
  '())

(define (find-application name)
  (let ((app (assoc name *applications-alist*)))
    (unless app
      (signal 'application-not-found))
    app))

(define (get-app-widgets app-name)
  (application-context-widgets (find-application name)))

(define (add-widget app-name)
  (application-context-widgets-set! ))

(define (find-widget application path)
    (let finder ([path path] [route (get-app-widgets application)])
      (if (null? path)
          (car route)
          (let ([next (assoc (car path) (car route))])
            (unless next
              (signal 'widget-not-found)
              (finder (cdr path) next))))))
            
(define (render-widget application widget)
  (let ([widget (find-widget application widget)])
    (if (widget-render widget)          
        ((widget-render widget) (widget-content widget)) ;If a function
        (render-sxml content))))                         ;Treat as SXML and render

(define (create-widget application renderer content)
  (get-app-widgets
   
;; Returns a function that defines a standard dispatcher
;; The standard dispatcher will try to match everything after the application path to a wiget
;; Leftover parameters will go as widget parameters
;; Routes should be a tree. 
(define (standard-dispatcher-function application-name)
  (letrec ((standard-dispatcher (lambda (request #!optional (url (request-uri request))))
                                  (let ((path (if (uri? url) ;Check if it is a uri-common or a list
                                                  (uri-path url) ;Break it into a list
                                                  url)))
                                    (if (atom? (car path)) ;Tries to match it to a widget
                                        (render-widget (find-widget application-name (car path)))
                                        (standard-dispatcher (routes request url)))))))
  standard-dispatcher)

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

(define (make-application title path #!key (session 'cookies) (database 'sqlite) (dispatcher 'standad-dispatcher))
  #f)


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
    (print-content-type (response-type response))
    (display ((response-body response)))))

(define (main)
  #f)

(main)