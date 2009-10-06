;; Markdown parser and HTML emitter for Chicken

;; List of Tokens

'HTML-BLOCK
'PARAGRAPH
'LINE-BREAK
'HEADER-1
'HEADER-2
'HEADER-3
'HEADER-4
'HEADER-5
'HEADER-6
'BLOCKQUOTE
'UNORDERED-LIST
'ORDERED-LIST
'CODE-BLOCK
'HORIZONTAL-RULE
'LINK-INLINE
'LINK-REFERENCE
'REFERENCED-LINK
'EMPHASIS
'EMPHASIS-DOUBLE
'CODE
'IMAGE-INLINE
'IMAGE-REFERENCE
'REFERENCED-IMAGE
'EMAIL-ADRESS
'BACKSLASH

(define (markdown-lexer input)
  (