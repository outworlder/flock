(use awful awful-sql-de-lite)

(define *database* "paleolithic.sqlite")

(define *assets*
  '((stylesheet "/assets/stylesheets")
    (image "/assets/images")
    (assets "/assets")
    (javascript "/assets/javascripts")))

(enable-db)
(db-credentials *database*)

(web-repl-access-control
 (lambda ()
   (member (remote-address) '("127.0.0.1"))))

(enable-web-repl "/repl")

(page-css "assets/stylesheets/paleolithic.css")
(page-charset "utf-8")

(debug-log (current-error-port))

(page-exception-message
	 (lambda (exn)
	   (<pre> convert-to-entities?: #t
	          (with-output-to-string
	            (lambda ()
	              (print-call-chain)
	              (print-error-message exn))))))

(define (default-database)
  *database*)

(enable-session #t)

(define-login-trampoline "/login-trampoline")

