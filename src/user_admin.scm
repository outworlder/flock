(use awful)
(include "src/authentication")

(define-page "user-admin"
  (lambda ()
    (main-template
     (lambda ()
       (<div> class: "user-list"
              "Users currently known to the system:"
              (display-all-users)
              (show-user-admin-controls))))) no-session: #t)

(define (display-all-users)
  (let ([user-list (fetch-all-users)])
    (if (null? user-list)
        "There are currently no users in the system."
        (map-web
         (lambda (user)
           (<div> class: "user-info"
                  (<div> class: "login-header"
                         "Login:")
                  (<div> class: "login-data"
                         (assoc 'login user)))) user-list))))

(define (show-user-admin-controls)
   (<div> class: "user-controls"
          (<a> href: "add-user" "Add a new user")))

(define-page "add-user"
  (lambda ()
    (<div> class: "user-form"
           (form
            (++
             "Add a new user"
             (<span> class: "user-field" "Username: ")
             (<input> type: "text" id: "username")
             (<span> class: "password-field" "Password: ")
             (<input> type: "text" id: "password")
             (<input> type: "submit" "Add User")
             (<input> type: "reset" "Clear")) action: "add-user-result" method: "post"))) no-session: #t)


(define-page "add-user-result"
  (lambda()
    (add-user ($ 'username) ($ 'password))) no-session: #t)