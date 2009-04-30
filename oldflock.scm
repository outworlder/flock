;; Blogging software written in Chicken Scheme
;; Hopefully, it will evolve into a full-blown
;; web framework.
;; 01/11/2008 Stephen Pedrosa Eilert

;; Using the CGI backend
;; TODO: This should be moved somewhere else and be customizable.
(use web-unity-cgi)
;; Using hart to generate HTML
(use hart)
;; syntax-rules macro system
(use alexpander)

;; handles incoming HTTP requests

;; List of action names and their mapping to functions.
(define lf:action-list
  '())

;; Process the configured routes and dispatch the request
;; to the appropriate handler.
;; The handler will be indicated in an alist by a macro.
;; TODO: By default, the string will be split by slashes, and the first one
;; will be the "action" to be called. The result will then be rendered.
;; TODO: Actually process the route and build an acceptable parameter list
(define (lf:process-routes path params)
  (let ((path-components (string-split path "/")))
    (apply (cadr (assoc (string->symbol (car path-components)) lf:action-list)) ; Lookup action name in the alist
           (list (cdr path-components) (wu:query-params))))) ; Send the rest of the path as a parameter, as well as any request params.

;; (define (lf:define-action action lambda)
;;   (set! lf:action-list (cons `(,action ,lambda) lf:action-list )))

(define-syntax lf:define-action
  (syntax-rules ()
    ((_ (action) form . forms)          ; Match expression
     (set! lf:action-list (cons
                           ; Action name - should be a symbol. TODO: Add syntax-error if it is not.
                           `(action ,(lambda(lf:path-args lf:query-parameters) (form . forms))) ; The rest of the forms as a lambda
                           lf:action-list)))))

(lf:define-action (index)
                  (hart (html (head (title "CGI Test"))
                              (body (h1 "CGI data") (hr)
                                    (ul (li (text: "Parameters: " (wu:params)))
                                        (li (text: "Query parameters: " (wu:query-params)))
                                        (li (text: "Request method: " (wu:request-method)))
                                        (li (text: "Path info: " (wu:path-info)))
                                        (li (text: "Path arguments:" lf:path-args))
                                        (li (text: "Query arguments:" lf:query-parameters)))))))

(lf:define-action (bigodagem)
                  (hart (html (head (title "Bigodagem test"))
                              (body (text: "omg bigodagem!")))))

(lf:define-action (test)
                  (print "<html><head><title></title></head><body>")
                  (print "omg path: " lf:path-args)
                  (print "omg query: " lf:query-parameters)
                  (print "</body></html>"))

(define (lf:process-requests)
  ;; Content-type should be configurable somehow.
  (wu:set-header! "Content-type" "text/html")
  (wu:write-headers)
  (lf:process-routes (wu:path-info) (wu:query-params)))

;; Runs the main processing "loop" (not much of a loop if using CGI)
(wu:run-handler lf:process-requests)

;; TODO: Add pretty error handler
;; TODO: Add Sqlite support
;; TODO: Add ability to specify actions in a different file
;; TODO: Add static page support (Milestone: OOTS script rewrite)