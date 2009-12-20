(define (html-body title body #!optional [headers '()] )
  (lambda ()
    `(html
      (head (title ,title)
            ,headers)
      (body
       ,(body)))))

(define (textfield id name type)
  `((label (@ (for ,id)) ,name)
    (input (@ (type ,type) (name ,name) (id ,id)))))

(define (make-asset-path type resource)
  (conc (cadr (assoc type *assets*)) resource))

(define (stylesheet-link href #!key (media 'screen))
  `(link (@ (rel "stylesheet") (type "text/css") (media ,media) (href ,(make-asset-path 'stylesheet href)))))

(define (javascript-link href)
  `(script (@ (type "text/javascript") (src ,(make-asset-path 'javascript href)))))


(define (get-error-message exn)
  (with-output-to-string
    (lambda ()
      (print-error-message exn))))

(define (get-backtrace)
  (with-output-to-string
    (lambda ()
      (print-call-chain))))

(define (STANDARD-EXCEPTION-SCREEN exn)
  (html-body "Error"
               (lambda ()
                 `(div (@ (class "error_box"))
                       (span "An error has ocurred:")
                       (div (@ (class "error_text"))
                            ,(get-error-message exn)
                            (br)
                            ,(get-backtrace))))
               (stylesheet-link "/error.css")))

(define (STANDARD-404 #!rest path)
  (html-body "404 Not Found"
              (lambda ()
                `(div (@ (class "error_box"))
                      (span "Page not found:")
                      (div (@ (class "error_text"))
                           ,path)))
              (stylesheet-link "/error.css")))
                