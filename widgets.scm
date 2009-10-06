(define (html-body title body #!optional [headers '()] )
  (lambda ()
    `(html
      (head (@ title ,title)
            ,headers)
      ,(body))))

(define (textfield id name type)
  `((label (@ (for ,id)) ,name)
    (input (@ (type ,type) (name ,name) (id ,id)))))

(define (stylesheet-link href #!key (media 'screen))
  `(link (@ (rel "stylesheet") (type "text/css") (media ,media) (href ,href))))