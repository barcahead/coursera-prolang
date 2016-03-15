
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

(define (sequence low high stride) 
  (if (> low high)
    null
    (cons low (sequence (+ low stride) high stride))))

(define (string-append-map xs suffix)
  (map (lambda (s) (string-append s suffix)) xs))

(define (list-nth-mod xs n)
  (cond [(< n 0) (error "list-nth-mod: negative number")]
        [(null? xs) (error "list-nth-mod: empty list")]
        [#t (car (list-tail xs (remainder n (length xs))))]))

(define (stream-for-n-steps s n) 
  (if (< n 1)
    null
    (letrec ([pr (s)])
      (cons (car pr) (stream-for-n-steps (cdr pr) (- n 1))))))

(define funny-number-stream
  (letrec ([f (lambda (x) 
                (cons (if (= (remainder x 5) 0)
                        (* x -1)
                        x) (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))

(define dan-then-dog
  (letrec ([dan (lambda () (cons "dan.jpg" dog))]
           [dog (lambda () (cons "dog.jpg" dan))])
    (lambda () (dan))))

(define (stream-add-zero s)
  (letrec ([pr (s)])
    (lambda () 
      (cons (cons 0 (car pr)) (stream-add-zero (cdr pr))))))

(define (cycle-lists xs ys)
  (letrec ([f (lambda (n)
                (cons 
                  (cons (list-nth-mod xs n) (list-nth-mod ys n))
                  (lambda () (f (+ n 1)))))])
    (lambda () (f 0))))

(define (vector-assoc v vec)
  (letrec ([f (lambda (n)
                (if (= n (vector-length vec)) 
                  #f
                  (letrec ([el (vector-ref vec n)])
                    (if (and (pair? el) (equal? (car el) v))
                      el
                      (f (+ n 1))))))])
    (f 0)))

(define (cached-assoc xs n)
  (letrec ([cache (build-vector n (lambda (i) #f))]
           [pos 0])
    (lambda (v) 
      (letrec ([c (vector-assoc v cache)])
        (if c
          c
          (letrec ([c (assoc v xs)])
            (if c
              (begin (vector-set! cache pos c) 
                (set! pos (if (= pos (- n 1))
                            0 (+ pos 1)))
                c)
              #f)))))))

(define-syntax while-less
  (syntax-rules (do)
    [(while-less e1 do e2)
      (letrec ([a e1]
               [f (lambda ()
                    (letrec ([b e2])
                      (if (< b a)
                        (f)
                        #t)))])
        (f))]))

