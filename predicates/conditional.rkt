#lang racket

(require "contract-helpers.rkt"
         "logic.rkt")

(module+ test
  (require rackunit
           "test-helpers.rkt"))

(provide
 (contract-out
  [if? (->* (predicate/c (-> any/c any))
            ((-> any/c any))
            (-> any/c any))]
  [when? (-> predicate/c (-> any/c any) (-> any/c any))]
  [unless? (-> predicate/c (-> any/c any) (-> any/c any))]
  [while? (-> predicate/c (-> any/c any) (-> any/c any))]
  [until? (-> predicate/c (-> any/c any) (-> any/c any))]
  [do-while? (-> predicate/c (-> any/c any) (-> any/c any))]
  [do-until? (-> predicate/c (-> any/c any) (-> any/c any))]))

;; Condition combinators

(define ((if? p f [g (λ (x) x)]) a) (if (p a) (f a) (g a)))
(define (when? p f) (if? p f void))
(define (unless? p f) (if? p void f))

(module+ test
  (define string?->symbol (if? string? string->symbol))
  (check-pred symbol? (string?->symbol "blah"))
  (check-pred number? (string?->symbol 8))
  
  (define string?->symbol-or-null (if? string? string->symbol (const null)))
  (check-pred symbol? (string?->symbol-or-null "foo"))
  (check-pred null? (string?->symbol-or-null 'blah))
  
  (define when-num?->string (when? number? number->string))
  (check-pred string? (when-num?->string 8))
  (check-pred void? (when-num?->string 'bar))
  
  (define unless-string?->null (unless? string? (const null)))
  (check-pred null? (unless-string?->null 8))
  (check-pred null? (unless-string?->null 'foo))
  (check-pred void? (unless-string?->null "smurf")))

;; Core point-free looping
(define ((while? p f) v)
  (if (p v)
      ((while? p f) (f v))
      v))

;; Logical inverse of while?
(define (until? p f) (while? (not? p) f))

;; Same as while?/until?, except f is called at least once on the input
;; Like a do while loop versus a while loop in imperative languages
(define (do-while? p f) (compose (while? p f) f))
(define (do-until? p f) (compose (until? p f) f))

(module+ test
  (define (negative? x) (< x 0))
  (define (add10 x) (+ x 10))
  (define (sub10 x) (- x 10))
  (check-eqv? ((while? negative? add10) -24) 6)
  (check-eqv? ((while? negative? add10) 13) 13)
  (check-eqv? ((until? negative? sub10) 28) -2)
  (check-eqv? ((until? negative? sub10) -100) -100)
  (check-eqv? ((do-while? negative? add10) -24) 6)
  (check-eqv? ((do-while? negative? add10) 13) 23)
  (check-eqv? ((do-until? negative? sub10) 28) -2)
  (check-eqv? ((do-until? negative? sub10) -100) -110))
