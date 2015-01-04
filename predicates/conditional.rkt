#lang racket

(require "contract-helpers.rkt")

(module+ test
  (require rackunit
           "test-helpers.rkt"))

(provide (contract-out [if? (->* (predicate/c (-> any/c any))
                                 ((-> any/c any))
                                 (-> any/c any))]
                       [when? (-> predicate/c (-> any/c any) (-> any/c any))]
                       [unless? (-> predicate/c (-> any/c any) (-> any/c any))]))

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

