predicates [![Build Status](https://travis-ci.org/jackfirth/predicates.svg?branch=master)](https://travis-ci.org/jackfirth/predicates) [![Coverage Status](https://coveralls.io/repos/jackfirth/predicates/badge.svg?branch=master)](https://coveralls.io/r/jackfirth/predicates?branch=master)
==========

[Documentation](http://pkg-build.racket-lang.org/doc/predicates/index.html)

*Deprecated* - For basic logic combinators, use `conjoin`, `disjoin`, and `negate` from `racket/function` instead. For predicate-constructing variants of `eq?` and friends, use a simple lambda shorthand library like `fancy-app` instead. For the more complex combinators, consider them unmaintained.

A racket package for creating predicates in a point-free style.

A *predicate* is a function that takes one argument and returns either true or false. You can think of it as a question, such as `even?` which returns true for even numbers and false for odd numbers. This package provides several tools for working with predicates.

Predicates can be combined logically

```racket
(filter (or? symbol? string?) '(1 a 3 "blah" b 4 5))
; -> '(a "blah" b)

(filter (and? number? even?) '(a b 2 5 6 "foo" bar 9 8))
; -> '(2 6 8)

(filter (not? symbol?) '(a b 2 3 "baz" d))
; -> '(2 3 "baz")
```

Predicates can be created to compare things

```racket
(filter (<? 5) '(3 4 5 6 7))
; -> '(3 4)
(filter (eq?? 'foo) '(foo bar baz))
; -> '(foo)
(define digit? (and? exact-positive-integer? (<? 10)))
(filter digit? '(a b 2 5 c "foo" 12 15 8))
; -> '(2 5 8)
```

Predicates can be created and combined to query lists

```racket
(nonempty-list? '(a b c)) ; -> #t
(nonempty-list? '()) ; -> #f
(nonsingular-list? '(a b c)) ; -> #t
(nonsingular-list? '(a)) ; -> #f

(define second-number? (second? number?))
(second-number? '(1 2 3)) ; -> #t
(second-number? '(1 a 3)) ; -> #f

(define three-nums? (listof? number? number? number?))
(three-nums? '(1 2 3)) ; -> #t
(three-nums? '(1 2 3 4)) ; -> #f
(three-nums? '(a b 2)) ; -> #f

(define starts-with-sym-str? (list-with-head? symbol? string?))
(starts-with-sym-str? '(a "foo" 1 2 3)) ; -> #t
(starts-with-sym-str? '(a 1 2 3)) ; -> #f

((length>? 2) '(a b c)) ; -> #t
((length>? 2) '(a)) ; -> #f
```

Once you've got all these fancy predicates, you can use them to add conditional logic to functions.

```racket
(define (halve x) (/ x 2))
(define (triple-add1 x) (add1 (* x 3)))
(define collatz (if? even? halve triple-add1))
(collatz 4) ; -> 2
(collatz 5) ; -> 16
(collatz 7) ; -> 22
(collatz 1) ; -> 4
```

Or use them as loop conditions in higher-order loop construction functions.

```racket
(define last (compose first (while? nonsingular-list? rest)))
(last '(1 2 3 4 5))
(define (last? p) (compose p last))
((last? even?) '(1 2 3 4 5))   ; -> #f
((last? even?) '(1 2 3 4 5 6)) ; -> #t
```

To install, run `raco pkg install predicates`. Then to use in a module, `(require predicates)`.
