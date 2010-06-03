(use aql)
(use srfi-19)

(define-record blog-post id title content publish-date visible)
(define-record-printer blog-post        ;TODO: It is not respecting the output port
  (lambda (record port)
    (print "[BLOG POST]")
    (print "Title: " (blog-post-title record))
    (print "Publish date: " (blog-post-publish-date record))
    (print "Visible: " (blog-post-visible record))
    (print "Content: " (blog-post-content record))))

(define (make-blog-post-from-record record)
  (apply make-blog-post record))

(define (add-blog-post title content #!key (visible SQL-FALSE))
  (db-exec (insert posts (content publishdate title visible) (? ? ? ?)) content (current-seconds) title visible))

(define (get-blog-posts)
  (map make-blog-post-from-record
       ($db (from posts (id title content publishdate visible) (order by (publishdate) desc)))))

(define (get-blog-post-by-id post-id)
  (make-blog-post-from-record (car ($db (from posts (id title content publishdate visible) (where (= 'id ?)) (limit 1)) values: (list post-id)))))

(define (get-latest-blog-post)
  (make-blog-post-from-record (db-query fetch (from posts (id title content publishdate visible) (order by (publishdate) desc) (limit 1)))))

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
                                                              