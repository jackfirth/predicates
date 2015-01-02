#lang racket

(require "contract-helpers.rkt")

(provide (contract-out [length>? (-> exact-nonnegative-integer? (-> list? boolean?))]
                       [first? (->** predicate/c (-> nonempty-list? boolean?))]
                       [second? (->** predicate/c (-> (and/c list? (length>? 1)) boolean?))]
                       [third? (->** predicate/c (-> (and/c list? (length>? 2)) boolean?))]
                       [fourth? (->** predicate/c (-> (and/c list? (length>? 3)) boolean?))]
                       [rest? (-> predicate/c (-> nonempty-list? boolean?))]
                       [all? (-> predicate/c (-> list? boolean?))]
                       [listof? (->** predicate/c predicate/c)]
                       [list-with-head? (->** predicate/c predicate/c)]
                       [not-null? predicate/c]
                       [nonempty-list? predicate/c]
                       [nonsingular-list? predicate/c]))

(require "logic.rkt")

(module+ test
  (require "test-helpers.rkt"))

;; List predicates

(define ((length>? n) lst) (> (length lst) n))
(define ((length=? n) lst) (= (length lst) n))
(define ((length<? n) lst) (< (length lst) n))

(define (((list-ref? ref) . ps) lst) ((apply and? ps) (ref lst)))
(define first? (list-ref? first))
(define second? (list-ref? second))
(define third? (list-ref? third))
(define fourth? (list-ref? fourth))

(define ((rest? p) lst) (p (rest lst)))
(define ((all? p) lst) (andmap p lst))
(define ((listof? . ps) lst)
  (and (list? lst)
       (= (length lst) (length ps))
       (andmap (λ (p a) (p a)) ps lst)))

(define ((list-with-head? . ps) lst)
  (and (list? lst)
       (>= (length lst) (length ps))
       (andmap (λ (p a) (p a)) ps (take (length ps) lst))))

(module+ test
  (check-pred-domain (first? symbol?) '(blah "foo" 8) '(2 #\a))
  (check-pred-domain (second? string?) '(6 "faz" c) '(2 #\a))
  (check-pred-domain (rest? empty?) '(blah) '(blah foo))
  (check-pred-domain (all? char?) '(#\a #\b #\c) '(#\a 5 #\c))
  (check-pred-domain (listof? string? char? char?) '("blah" #\a #\b) '("foo" #\a 8)))

(define not-null? (not? null?))
(define nonempty-list? (and? list? not-null?))
(define nonsingular-list? (and? list? not-null? (rest? not-null?)))

(module+ test
  (check-pred-domain not-null? 8 '())
  (check-pred-domain nonempty-list? '(4 5) 8)
  (check-pred-domain nonsingular-list? '(foo bar) '(foo)))

