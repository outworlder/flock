(use awful)

(define-page "admin"
  (lambda ()
    (++
     (<h1> "Blog Administration")
     (<h2> "User logged in: " ($ 'user))
     (<div> id: "rightbar"
            (admin-menu)))) css: '("/assets/stylesheets/paleolithic.css" "/assets/stylesheets/admin.css"))


(define (admin-menu) 
  (++
   (<div> id: "admin_menu"
          (<ul>
           (<li> (link "/user-admin" "User administration"))
           (<li> (link "/post-admin" "Posts"))
           (<li> (link "/tags-admin" "Tags"))
           (<li> (link "/configuration-admin" "Configuration"))))))