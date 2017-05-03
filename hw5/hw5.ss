#lang racket
(define (null-ld? x) (cond [(pair? x) (if (eq? (car x) (cdr x)) #t #f)] [else #f]))

(define (listdiff? x) (cond [(pair? x) (if (eq? (car x) (cdr x)) #t (if (pair? (car x)) (listdiff? (cons (cdr (car x)) (cdr x))) #f))][else #f]))

(define (cons-ld x listdiff) (cons (cons x (car listdiff)) (cdr listdiff)))

(define (car-ld listdiff)(cond [(not (listdiff? listdiff)) (error "error")][(null-ld? listdiff) (error "error")][else (car(car listdiff))]))

(define (cdr-ld listdiff)(cond [(not (listdiff? listdiff)) (error "error")][(null-ld? listdiff) (error "error")][else (cons (cdr (car listdiff)) (cdr listdiff))]))

(define (listdiff . args)(cond [(empty? args) (cons '() '())][else (cons args '())]))

(define (length-ld listdiff)(cond [(not (listdiff? listdiff)) (error "error")][else (let loop ((lis listdiff)(length 0))(if (null-ld? lis) length (loop (cdr-ld lis) (+ 1 length))))]))

(define (inloop arg lis)
  (if (null-ld? arg) lis (inloop (cdr-ld arg) (append lis (list (car-ld arg)))))) 
  
(define (append-ld . args)
  (let loop ((args args) (lis '()))
    (cond [(empty? args) (cons lis '())]
          [else 
           (if (not(listdiff? (car args)))
               (error "element not a listdiff")
               (loop (cdr args) (append lis (inloop (car args) '()))))]))) 

(define (assq-ld x alistdiff)
  (cond 
        [(null-ld? alistdiff) #f]
        [(eq? (car (car-ld alistdiff)) x) (car-ld alistdiff) ]
        [else (assq-ld x (cdr-ld alistdiff))]))

(define (list->listdiff lis)
  (cons lis '()))

(define (listdiff->list listdiff)
  (cond [(null-ld? listdiff) '()]
        [else (cons (car-ld listdiff) (listdiff->list (cdr-ld listdiff)))]))

;(define-namespace-anchor anc)
;(define ns (namespace-anchor->namespace anc))

(define (expr-returning listdiff)
  (cond [(not (listdiff? listdiff)) (error "not listdiff")]
        [else (list 'quote (list->listdiff (listdiff->list listdiff)))])) 


#|
(define ils (append '(a e i o u) 'y))
(define d1 (cons ils (cdr (cdr ils))))
(define d2 (cons ils ils))
(define d3 (cons ils (append '(a e i o u) 'y)))
(define d4 (cons '() ils))
(define d5 0)
(define d6 (listdiff ils d1 37))
(define d7 (append-ld d1 d2 d6))
(define e1 (expr-returning d1))


(listdiff? d1)                         ;===>  #t
(listdiff? d2)                         ;===>  #t
(listdiff? d3)                         ;===>  #f
(listdiff? d4)                         ;;===>  #f
(listdiff? d5)                        ; ===>  #f
(listdiff? d6)                        ; ===>  #t
(listdiff? d7)                        ; ===>  #t

(null-ld? d1)                          ;===>  #f
(null-ld? d2)                          ;===>  #t
(null-ld? d3)                         ; ===>  #f
(null-ld? d6)                         ; ===>  #f

(car-ld d1)                           ; ===>  a
;(car-ld d2)                           ; ===>  error
;(car-ld d3)                           ; ===>  error
(car-ld d6)                           ; ===>  (a e i o u . y)

(length-ld d1)                         ;===>  2
(length-ld d2)                        ; ===>  0
;(length-ld d3)                         ;===>  error
(length-ld d6)                        ; ===>  3
(length-ld d7)                        ; ===>  5

(define kv1 (cons d1 'a))
(define kv2 (cons d2 'b))
(define kv3 (cons d3 'c))
(define kv4 (cons d1 'd))
(define d8 (listdiff kv1 kv2 kv3 kv4))
(eq? (assq-ld d1 d8) kv1)              ;===>  #t
(eq? (assq-ld d2 d8) kv2)             ; ===>  #t
(eq? (assq-ld d1 d8) kv4)              ;===>  #f

(eq? (car-ld d6) ils)                 ; ===>  #t
(eq? (car-ld (cdr-ld d6)) d1)         ; ===>  #t
(eqv? (car-ld (cdr-ld (cdr-ld d6))) 37);===>  #t
(equal? (listdiff->list d6)
        (list ils d1 37))             ; ===>  #t
(eq? (list-tail (car d6) 3) (cdr d6)) ; ===>  #t

(listdiff->list (eval e1 ns))             ;===>  (a e)
(equal? (listdiff->list (eval e1 ns))
       (listdiff->list d1))           ;===>  #t
|#