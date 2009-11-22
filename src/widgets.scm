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

(define (STANDARD-EXCEPTION-SCREEN exn)
  ((html-body "Error"
              (lambda ()
                `(div (@ (class "error_box"))
                      (span "An error has ocurred:")
                      (div (@ (class "error_text"))
                      ,((condition-property-accessor 'exn 'message) exn))))
              (stylesheet-link "/error.css"))))
