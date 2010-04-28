(use awful)

(define-page "/post-new"
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

;; Generates a "permalink". Permalinks can be:
;; <method>://<host>/posts?id=<id>   [STANDARD]
;; <method>://<host>/posts/<date>-post-title-with-dashes-separating-sentences [SEO]
;; <method>://<host>/posts/<id> [FRIENDLY]
;; TODO: Instead of concatenating strings, use a library to build URLs
(define (make-post-permalink post #!key '(type 'FRIENDLY) #!key '(link-name "Permalink") #!key '(post-root "/posts"))
  (case type
    (['STANDARD] (link link-name (string-append post-root "&id=" (blog-post-id post))))
    (['SEO]) (link link-name (string-append post-root "/" (string-intersperse (string-split (blog-post-title)) "-")))
    (['FRIENDLY]) (link link-name (string-append post-root "/" (blog-post-id post)))))