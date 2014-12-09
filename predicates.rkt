#lang racket

(provide (contract-out [true? predicate/c]
                       [and? predicate*->/c]
                       [or? predicate*->/c]
                       [not? predicate->/c]
                       [and?* (->** predicate/c predicate*/c)]
                       [or?* (->** predicate/c predicate*/c)]
                       [eq?? predicate->/c]
                       [equal?? predicate->/c]
                       [eqv?? predicate->/c]
                       [=? (-> real? (-> real? boolean?))]
                       [<? (-> real? (-> real? boolean?))]
                       [>? (-> real? (-> real? boolean?))]
                       [<=? (-> real? (-> real? boolean?))]
                       [>=? (-> real? (-> real? boolean?))]
                       [length>? (-> exact-nonnegative-integer? (-> list? boolean?))]
                       [first? (->** predicate/c (-> nonempty-list? boolean?))]
                       [second? (->** predicate/c (-> (and? list? (length>? 1)) boolean?))]
                       [third? (->** predicate/c (-> (and? list? (length>? 2)) boolean?))]
                       [fourth? (->** predicate/c (-> (and? list? (length>? 3)) boolean?))]
                       [rest? (-> predicate/c (-> nonempty-list? boolean?))]
                       [all? (-> predicate/c (-> list? boolean?))]
                       [listof? (->** predicate/c (-> list? boolean?))]
                       [list-with-head? (->** predicate/c predicate/c)]
                       [not-null? predicate/c]
                       [nonempty-list? predicate/c]
                       [nonsingular-list? predicate/c]
                       [if? (parametric->/c (X Y Z) (->* (predicate/c (-> X Y)) ((-> X Z)) (-> X (or/c Y Z))))]
                       [when? (parametric->/c (X Y) (-> predicate/c (-> X Y) (-> X (or/c Y void?))))]
                       [unless? (parametric->/c (X Y) (-> predicate/c (-> X Y) (-> X (or/c Y void?))))]
                       [in-range? (-> real? real? predicate/c)]))

(define (->** rest-contract result-contract)
  (->* () () #:rest (listof rest-contract) result-contract))
(define predicate*/c (->** any/c boolean?))
(define predicate*->/c (->** predicate/c predicate/c))
(define predicate->/c (-> predicate/c predicate/c))

(module+ test
  (require rackunit)
  (define-check (check-pred-domain p true-input false-input)
    (check-true (p true-input))
    (check-false (p false-input)))
  (define-check (check-pred-domain* p true-inputs false-inputs)
    (map (λ (a) (check-true (p a))) true-inputs)
    (map (λ (a) (check-false (p a))) false-inputs)))

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

(define ((length>? n) lst) (> (length lst) n))
(define (((list-ref? ref) . ps) lst) ((apply and? ps) (ref lst)))
(define first? (list-ref? first))
(define second? (list-ref? second))
(define third? (list-ref? third))
(define fourth? (list-ref? fourth))
(define ((rest? p) lst) (p (rest lst)))
(define ((all? p) lst) (andmap p lst))
(define ((listof? . ps) lst) (andmap (λ (p a) (p a)) ps lst))

(define (list-with-head? . ps)
  (if (empty? ps)
      list?
      (and? nonempty-list?
            (first? (first ps))
            (rest? (apply list-with-head?
                          (rest ps))))))

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

(define (in-range? low high [exclusive #f])
  (let-values ([(<? >?) (if exclusive (values <? >?) (values <=? >=?))])
    (and? number? (<? high) (>? low))))

(module+ test
  (check-pred-domain* (in-range? 4 10) '(4 5 6 7 8 9 10) '(1 2 3 11 12))
  (check-pred-domain* (in-range? 4 10 #t) '(5 6 7 8 9) '(1 2 3 4 10 11 12)))