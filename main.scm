;; Flock framework

(require-extension uri-common)
(require-extension intarweb)
(require-extension sql-de-lite)
(require-extension defstruct)

;; Steps:
;; - Get the request
;; - Break down into the various parts (host, port, etc)
;;   - Update: There is also an URL decoding step, which is handled by the webserver itself.
;; - Go through the routes file trying to find a match
;;   - Update: Since we are all trendy and weby-two-point-zeroy-like, the routes file identifies resources.
;; - Execute the matching action
;; - If no action matches, display the error page
;; - If the top exception handler catches an exception, display the 500 error page
;; - There are no controllers. When are we going to display the 404 page?
;;   - Update: When a resource does not match.

;; TODO: Implement the model - requires SqLite access
;;   - Update: This will not be (at first) an Active-Record-like implementation. Instead, a plain old db access returning assoc-lists.

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
;; protocol://localhost.localdomain:port/resource/.../resource/identifier&other_params
;; TODO: Resources can be nested
;; TODO[1]: If resources are nested, then we actually have a website tree, instead of an alist. Therefore, the route matcher will do a tree search instead.
;; NOTE: Resources are essentially CRUDs, but they might choose not to implement a given operation.
;; TODO[2]: Figure out how to describe nested resources. Nested s-exps are a possibility, but it can get messy.
;; Protocol and host are irrelevant to the route matcher
;;
(define routes-tree
  '())

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

;; NOTE: Cute macro below was commented out. Turns out a plain alist is more than adequate. Thanks Freud.
;; (define-syntax let-environment-variables
;;   (syntax-rules ()
;;     ((let-environment-variables ((name environment) ... ) forms ...)
;;      (let ((name (get-environment-variable environment)) ...)
;;        forms ...))))

;; This translates to:
;;(let ((server-software (get-environment-variable "SERVER_SOFTWARE")))
  ;; thunk
;;  )

(define (get-env env-vars var)
  (cadr (assoc var env-vars)))

;; Breaks down the URL into useful components.
;; Should return:
;; Controller
;; Action
;; (List of parameters)
(define (break-url url)
  (let ((uri-ref (uri-reference url)))
    (unless? (uri? uri-ref)
	     (begin
	       (uri-query (uri-ref))))))

;; Returns an alist containing the CGI environment variables
(define (make-cgi-env-alist)
  (map
       (lambda (x)
	 (list x (get-environment-variable x)))  cgi-environment-variables-list))

;; Buzzword compliance code. Returns the intended verb.
(define (restful-verb request)
  (case (string->symbol (get-env request "REQUEST_METHOD"))
    ((GET) 'read)
    ((POST) 'create)
    ((PUT) 'update)
    ((DELETE) 'delete)))

;; This calls the route matcher to forward requests to, according to the path and request method
;; (buzzword-compliance "This is required for Restful routes")
(define (handle-requests request verb uri)
  #f)

;; This will decode the (initially) CGI parameters
(define (decode-params)
  (let ((request (make-cgi-env-alist)))
    (handle-requests request (restful-verb (get-env request "REQUEST_METHOD") (break-url (get-env request "PATH_INFO"))))))
