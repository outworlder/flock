(define-page "post"
  (lambda ()
    (main-template
     (lambda ()
       (++ (<div> class: "header"
                  "Post new entry")
           (<div> class: "site_content"
                  (new-post-form)))))))
                                
(define (new-post-form)
  (form
   (lambda ()
     (++
      (<div> class: "field_title"
             "Title:"
             (<input> type: "text" id: "post_title"))
      (<div> class: "field_post"
             "Post:"
             (<textarea> id: "post_body")))) action: "/add-post" method: "post"))
