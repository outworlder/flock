;; Flock framework

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

;; URL breakdown:
;; protocol://localhost.localdomain:port/controller/action/id

;; TODO: Implement the model - requires SqLite access
;; TODO: Figure out how to handle the controllers in a non-OO language. No OO frameworks will be added.

;; TODO: Add the exception handler here.

(define (handle-errors)
  "Error page here blahblah")

;; Request method should not matter.
(define (process-requests)
  #f)
