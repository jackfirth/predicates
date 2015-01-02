#lang racket

(require "contract-helpers.rkt")

(provide (contract-out [eq?? predicate->/c]
                       [equal?? predicate->/c]
                       [eqv?? predicate->/c]
                       [=? (-> real? (-> real? boolean?))]
                       [<? (-> real? (-> real? boolean?))]
                       [>? (-> real? (-> real? boolean?))]
                       [<=? (-> real? (-> real? boolean?))]
                       [>=? (-> real? (-> real? boolean?))]
                       [in-range? (-> real? real? predicate/c)]))

(require "logic.rkt")

(module+ test
  (require "test-helpers.rkt"))

;; Comparison predicates

(define-values (eq?? equal?? eqv?? =? <? >? <=? >=?)
  (apply values
         (map (λ (cmp) (λ (a) (λ (b) (cmp b a))))
              (list eq? equal? eqv? = < > <= >=))))

(module+ test
  (check-pred-domain (eq?? 'foo) 'foo 5)
  (check-pred-domain (equal?? '(foo bar)) '(foo bar) '(foo bar baz))
  (check-pred-domain (eqv?? #\a) #\a 8)
  (check-pred-domain (=? 4) 4.0 8)
  (check-pred-domain (<? 4) 2 4)
  (check-pred-domain (>? 7) 10 7)
  (check-pred-domain (<=? 10) 10 12)
  (check-pred-domain (>=? 5) 5 3))

;; Range-checking

(define (in-range? low high [exclusive #f])
  (let-values ([(<? >?) (if exclusive (values <? >?) (values <=? >=?))])
    (and? number? (<? high) (>? low))))

(module+ test
  (check-pred-domain* (in-range? 4 10) '(4 5 6 7 8 9 10) '(1 2 3 11 12))
  (check-pred-domain* (in-range? 4 10 #t) '(5 6 7 8 9) '(1 2 3 4 10 11 12)))