#lang racket

(require "contract-helpers.rkt")

(provide (contract-out [true? predicate/c]
                       [without-truthiness (-> procedure? procedure?)]
                       [and? predicate*->/c]
                       [or? predicate*->/c]
                       [not? predicate->/c]
                       [and?* (->** predicate/c predicate*/c)]
                       [or?* (->** predicate/c predicate*/c)]))

(module+ test
  (require rackunit
           "test-helpers.rkt"))

;; Logic predicates

(define (true? a) (if a #t #f))

(module+ test
  (check-true (true? 'a))
  (check-true (true? #t))
  (check-false (true? #f)))

(define ((and? . ps) a) (andmap (λ (p) (p a)) ps))
(define ((or? . ps) a) (ormap (λ (p) (p a)) ps))
(define ((not? p) a) (not (p a)))

(module+ test
  (check-pred-domain (not? number?) 'foo 4)
  (check-pred-domain* (and? number? (not? real?)) '(1+2i) '(8 odd))
  (check-pred-domain* (or? symbol? string?) '(blah "foo") '(8)))

(define ((and?* . ps) . as) (andmap (λ (p a) (p a)) ps as))
(define ((or?* . ps) . as) (ormap (λ (p a) (p a)) ps as))

(module+ test
  (define num-and-str? (and?* number? string?))
  (check-true (num-and-str? 8 "blah"))
  (check-false (num-and-str? 8 2))
  (check-false (num-and-str? "foo" "bar"))
  (check-false (num-and-str? 4 'neither))
  (define first-num-or-second-sym? (or?* number? symbol?))
  (check-true (first-num-or-second-sym? 4 "blah"))
  (check-true (first-num-or-second-sym? "foo" 'bar))
  (check-true (first-num-or-second-sym? 4 'baz))
  (check-false (first-num-or-second-sym? "smurf" '())))

;; Helper for dealing with truthy predicates

(define (without-truthiness f)
  (compose true? f))

(module+ test
  (define member? (without-truthiness member))
  (check-true (member? 'a '(a b c)))
  (check-false (member? 1 '(a b c))))