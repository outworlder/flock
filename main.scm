;; Flock framework

(require-extension uri-common)
(require-extension intarweb)
(require-extension sql-de-lite)

;; Steps:
;; - Get the request
;; - Break down into the various parts (host, port, etc)
;; - Go through the routes file trying to find a match
;; - Execute the matching action
;; - If no action matches, display the error page
;; - If the top exception handler catches an exception, display the 500 error page
;; - There are no controllers. When are we going to display the 404 page?


;; TODO: Implement the model - requires SqLite access
;; TODO: Figure out how to handle the controllers in a non-OO language. No OO frameworks will be added.

;; TODO: Add the exception handler here.
(define (handle-errors)
  "Error page here blahblah")


;; Note about CGI requests:
;; CGI will send information using environment variables, command-line parameters and stdin


;; -----------------------------------------------------------------------------
;; Routes section
;; -----------------------------------------------------------------------------

;; Routes will follow a simple structure at first.

;; URL breakdown:
;; protocol://localhost.localdomain:port/controller/action/[named_param_1]/[named_param_2]?param3=value&param4=value
;; Protocol and host are irrelevant to the route matcher
;; 
(define routes-alist
  '())

;; Request method should not matter.
;; Process requests will initially process CGI requests. We have to parse the headers.
;; Request processing pseudocode:
;; 1- Get request and query parameters. Split it into request host, port, and query
;; 2- Decode query URL
;; 3- Match against the route rules
;; 4- Split the data between route variables and params (as in Rails, get or post parameters)
;; OPTIONAL: Restful routes: Interpret the request verb and redirect to the appropriate action.
(define (process-requests)
  (let ((request-params (decode-params)))
    ()))

(define-syntax let-environment-variables
  (syntax-rules ()
    ((let-environment-variables ((name environment) ... ) forms ...)
     (let ((name (get-environment-variable environment)) ...)
       forms ...))))

;; This translates to:
;;(let ((server-software (get-environment-variable "SERVER_SOFTWARE")))
  ;; thunk
;;  )

;; Breaks down the URL into useful components.
;; Should return:
;; Controller
;; Action
;; (List of parameters)
(define (break-url url)
  (let ((uri-ref (uri-reference url)))
    (unless? (uri? uri-ref)
	     (begin
	       (uri-query (uri-ref))
	       
  

;; This will decode the (initially) CGI parameters
(define (decode-params)
  (let-environment-variables
   ((server-software "SERVER_SOFTWARE")
    (server-name  "SERVER_NAME")
    (gateway-interface-version "GATEWAY_INTERFACE")
    (server-protocol "SERVER_PROTOCOL")
    (server-port "SERVER_PORT")
    (request-method "REQUEST_METHOD")
    (path-info "PATH_INFO")
    (path-translated "PATH_TRANSLATED")
    (script-name "SCRIPT_NAME")
    (query-string "QUERY_STRING")
    (remote-host "REMOTE_HOST")
    (remote-addr "REMOTE_ADDR")
    (auth-type "AUTH_TYPE")
    (remote-user "REMOTE_USER")
    (remote-ident "REMOTE_IDENT")
    (content-type "CONTENT_TYPE")
    (content-length "CONTENT_LENGTH"))
   (case request-method
     (("GET") handle-get))
