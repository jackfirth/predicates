#lang racket

(provide
 (contract-out [->** (-> contract? contract? contract?)]
               [predicate*/c contract?]
               [predicate*->/c contract?]
               [predicate->/c contract?]))

;; Contract for a function that accepts arbitrarily many arguments
;; of rest-contract and returns a result of result-contract

(define (->** rest-contract result-contract)
  (->* () () #:rest (listof rest-contract) result-contract))

;; Contract for a predicate that accepts more than one input

(define predicate*/c (->** any/c boolean?))

;; Contract for a predicate combinator - accepts some predicates
;; and returns a new predicate

(define predicate*->/c (->** predicate/c predicate/c))

;; Contract for a predicate combinator that accepts one predicate
;; and returns a new predicate

(define predicate->/c (-> predicate/c predicate/c))

