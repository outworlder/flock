(use aql)
(use srfi-19)
(use coops)
(use orly)

(define-model <blog-post> "posts"
  (id title content publishdate visible))

(has-many <blog-post> <blog-comment> comments foreign-key: id)

(define-method (print-object (obj <blog-post>) #!optional (port (current-output-port)))
  (if (slot-initialized? obj 'id)
      (fprintf port "<#blog-post id:[~A] title:[\"~A\"]>" (slot-value obj 'id) (slot-value obj 'title))
      (fprintf port "<#blog-post [uninitialized]>")))

(define (add-blog-post title content #!key (visible SQL-FALSE))
  (db-exec (insert posts (content publishdate title visible) (? ? ? ?)) content (current-seconds) title visible))

(define (get-blog-posts)
  (find-all <blog-post>))

(define (get-blog-post-by-id post-id)
  (find-by-id <blog-post> post-id))

(define (get-latest-blog-post)
  (find <blog-post> conditions: `(order by (publishdate) desc)))

;; How to map permalinks to the original post?
;; Assuming SEO permalinks for now

(define (get-post-by-permalink permalink)
  (let ([url-components (string-split permalink "/")])
    (if (< (length url-components) 4)
        #f                              ; Fail - insufficient data
        (let ([year (car url-components)]
              [month (cadr url-components)]
              [day (caddr url-components)]
              [title (cadddr url-components)])
          (get-post-by-date-and-title (make-date 0 0 0 0 (string->number day) (string->number month) (string->number year) 0) title)))))

(define (get-post-by-date-and-title day month year title)
  (let ([date-range-end (time->seconds (date->time (make-date 0 59 59 23 day month year 0)))]
        [date-range-begin (time->seconds (date->time (make-date 0 0 0 0 day month year 0)))])
    (from posts (id title content publishdate visible) (where (and (>= 'publishdate date-range-begin)
                                                                   (and (<= 'publishdate date-range-end)
                                                                        (like 'title title)))))))
                                                              