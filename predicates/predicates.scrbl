#lang scribble/manual

@(require scribble/eval
          (for-label predicates
                     racket/base
                     racket/list))

@title{Predicates}

@(define the-eval (make-base-eval))
@(the-eval '(require "main.rkt"))
@(define-syntax-rule (module-examples e ...)
   (examples #:eval the-eval e ...))

@defmodule[predicates]

@author[@author+email["Jack Firth" "jackhfirth@gmail.com"]]

These functions allow for easy construction of @italic{predicates} - functions that take
an input and return a boolean - for use with contracts and @racket[filter] variants. This
library makes it easy to define predicates in a @italic{point-free} style, meaning that
you can construct new predicates in terms of old predicates without defining them as
functions with arguments.

source code: @url["https://github.com/jackfirth/predicates"]

@section{Logic Predicate Constructors}

@defproc[(and? [pred (-> any? boolean?)] ...+) (-> any? boolean?)]{
  Combines each @racket[pred] into a single predicate that returns @racket[#t] for its input
  if all the original @racket[pred]s return @racket[#t] for the input.
  @module-examples[
    (define small-positive-number? (and? number? (λ (x) (< 0 x 10))))
    (small-positive-number? 6)
    (small-positive-number? 123)
    (small-positive-number? 'foo)
    ]}

@defproc[(or? [pred (-> any? boolean?)] ...+) (-> any? boolean?)]{
  Combines each @racket[pred] into a single predicate that returns @racket[#t] for its
  input if any of the original @racket[pred]s return @racket[#t] for the input.
  @module-examples[
    (define symbol-or-string? (or? symbol? string?))
    (symbol-or-string? 'symbol)
    (symbol-or-string? "string")
    (symbol-or-string? 123)
    ]}

@defproc[(not? [pred (-> any? boolean?)]) (-> any? boolean?)]{
  Returns a new predicate that returns @racket[#t] for its input if the original
  predicate returns @racket[#f] for the input.
  @module-examples[
    (define nonzero? (not? zero?))
    (nonzero? 8)
    (nonzero? 0)
    (nonzero? -5)
    ]}

@defproc[(and?* [pred (-> any? boolean?)] ...+) (->* () () #:rest any? boolean?)]{
  Combines each @racket[pred] into a single function that accepts any number of
  arguments and returns @racket[#t] if the first @racket[pred] returns @racket[#t]
  for the first argument, and the second @racket[pred] returns @racket[#t] for the
  second argument, and so on for each @racket[pred] and each argument.
  @module-examples[
    (define number-and-string? (and?* number? string?))
    (number-and-string? 5 "foo")
    (number-and-string? 5 'neither)
    (number-and-string? 'neither "foo")
    (number-and-string? 'neither 'neither)
    ]}

@defproc[(or?* [pred (-> any? boolean?)] ...+) (->* () () #:rest any? boolean?)]{
  Combines each @racket[pred] into a single function in a manner similar to
  @racket[and?*], except the resulting function returns @racket[#t] if any of
  the @racket[pred]s return @racket[#t] for their argument.
  @module-examples[
    (define number-or-string? (or?* number? string?))
    (number-or-string? 5 "foo")
    (number-or-string? 5 'neither)
    (number-or-string? 'neither "foo")
    (number-or-string? 'neither 'neither)
    ]}

@section{Comparison Predicate Constructors}

@defproc[(eq?? [v any?]) (-> any? boolean?)]{
  Returns a predicate that returns @racket[#t] for any input that is @racket[eq?]
  to @racket[v].
  @module-examples[
    (define eq-foo? (eq?? 'foo))
    (eq-foo? 'foo)
    (eq-foo? 8)
    (eq-foo? 'bar)
    ]}

@defproc[(eqv?? [v any?]) (-> any? boolean?)]{
  Returns a predicate that returns @racket[#t] for any input that is @racket[eqv?]
  to @racket[v].
  @module-examples[
    (define eqv-7? (eqv?? 7))
    (eqv-7? 7)
    (eqv-7? 8)
    (eqv-7? 'foo)
    ]}

@defproc[(equal?? [v any?]) (-> any? boolean?)]{
  Returns a predicate that returns @racket[#t] for any input that is @racket[equal?]
  to @racket[v].
  @module-examples[
    (define foo-bar-baz? (equal?? '(foo bar baz)))
    (foo-bar-baz? '(foo bar baz))
    (foo-bar-baz? '(foo foo foo))
    (foo-bar-baz? 8)
    ]}

@defproc[(=? [v any?]) (-> any? boolean?)]{
  Returns a predicate that returns @racket[#t] for any input that is @racket[=]
  to @racket[v].
  @module-examples[
    (define 7? (=? 7))
    (7? 7)
    (7? (+ 3 4))
    (7? 0)
    ]}

@defproc[(<? [v real?]) (-> real? boolean?)]{
  Returns a predicate that returns @racket[#t] for any real input that is @racket[<]
  than @racket[v].
  @module-examples[
    (define <10? (<? 10))
    (<10? 5)
    (<10? 15)
    (<10? -5)
    ]}

@defproc[(>? [v real?]) (-> real? boolean?)]{
  Returns a predicate that returns @racket[#t] for any real input that is @racket[>]
  than @racket[v].
  @module-examples[
    (define >10? (>? 10))
    (>10? 15)
    (>10? 5)
    ]}

@defproc[(<=? [v real?]) (-> real? boolean?)]{
  Returns a predicate that returns @racket[#t] for any real input that is @racket[<=]
  to @racket[v].
  @module-examples[
    (define <=10? (<=? 10))
    (<=10? 10)
    (<=10? 5)
    (<=10? 15)
    (<=10? -5)
    ]}

@defproc[(>=? [v real?]) (-> real? boolean?)]{
  Returns a predicate that returns @racket[#t] for any real input that is @racket[>=]
  to @racket[v].
  @module-examples[
    (define >=10? (>=? 10))
    (>=10? 10)
    (>=10? 15)
    (>=10? 5)
    ]}

@section{List Predicates}

@defproc[(not-null? [v any?]) boolean?]{
  Returns @racket[#t] if @racket[v] is @racket[null?], and returns @racket[#f] otherwise.
  Equivalent to @racket[(not? null?)].
  @module-examples[
    (not-null? null)
    (not-null? '())
    (not-null? 'foo)
    ]}

@defproc[(nonempty-list? [v any?]) boolean?]{
  Returns @racket[#t] if @racket[v] is a list containing at least one element, and returns
  @racket[#f] otherwise. Equivalent to @racket[(and? list? (not? null?))].
  @module-examples[
    (nonempty-list? '(foo bar baz))
    (nonempty-list? null)
    (nonempty-list? '())
    (nonempty-list? 'foo)
    ]}

@defproc[(nonsingular-list? [v any?]) boolean?]{
  Returns @racket[#t] if @racket[v] is a list containing at least two elements, and returns
  @racket[#f] otherwise. Equivalent to @racket[(and? list? (not? null?) (rest? (not? null?)))].
  @module-examples[
    (nonsingular-list? '(foo bar baz))
    (nonsingular-list? '(foo))
    (nonsingular-list? '())
    (nonsingular-list? null)
    (nonsingular-list? 7)
    ]}

@defproc[(length>? [n exact-nonnegative-integer?]) (-> list? boolean?)]{
  Returns a predicate that returns @racket[#t] for any list with more than @racket[n]
  elements.
  @module-examples[
    (define more-than-four-elements? (length>? 4))
    (more-than-four-elements? '(foo bar baz bar foo))
    (more-than-four-elements? '(foo bar baz bar))
    (more-than-four-elements? '())
    (more-than-four-elements? null)
    ]}

@defproc[(length=? [n exact-nonnegative-integer?]) (-> list? boolean?)]{
  Returns a predicate that returns @racket[#t] for any list with @racket[n] elements.
  @module-examples[
    (define four-element-list? (length=? 4))
    (four-element-list? '(foo bar baz bar))
    (four-element-list? '(foo bar baz bar foo))
    (four-element-list? '(foo bar baz))
    (four-element-list? '())
    ]}

@defproc[(length<? [n exact-nonnegative-integer?]) (-> list? boolean?)]{
  Returns a predicate that returns @racket[#t] for any list with fewer than @racket[n]
  elements.
  @module-examples[
    (define less-than-four-elements? (length<? 4))
    (less-than-four-elements? '(foo bar baz))
    (less-than-four-elements? '(foo bar baz bar))
    (less-than-four-elements? '())
    ]}

@deftogether[(@defproc[(first? [pred (-> any? boolean?)] ...+) (-> nonempty-list? boolean?)]
              @defproc[(second? [pred (-> any? boolean?)] ...+) (-> (and? list? (length>? 1)) boolean?)]
              @defproc[(third? [pred (-> any? boolean?)] ...+) (-> (and? list? (length>? 2)) boolean?)]
              @defproc[(fourth? [pred (-> any? boolean?)] ...+) (-> (and? list? (length>? 3)) boolean?)])]{
  Returns a predicate that returns @racket[#t] for any list whose first, second, third,
  or fourth item satisfies @racket[(and? pred ...)], depending on the procedure chosen.
  @module-examples[
    (define second-is-number? (second? number?))
    (second-is-number? '(foo 4 bar baz))
    (second-is-number? '(foo bar baz))
    (second-is-number? '(5 5))
    ]}

@defproc[(rest? [pred (-> any? boolean?)]) (-> list? boolean?)]{
  Returns a predicate that returns @racket[#t] for any list for which the @racket[rest]
  of the list satisfies @racket[pred].
  @module-examples[
    (define rest-numbers? (rest? (all? number?)))
    (rest-numbers? '(foo 1 2 3))
    (rest-numbers? '(foo 1))
    (rest-numbers? '(foo))
    (rest-numbers? '(foo bar baz))
    (rest-numbers? '(foo bar 1))
    ]}

@defproc[(all? [pred (-> any? boolean?)]) (-> list? boolean?)]{
  Returns a predicate that returns @racket[#t] for any list for which every element in
  the list satisfies @racket[pred].
  @module-examples[
    (define all-numbers? (all? number?))
    (all-numbers? '(1 2 3 4))
    (all-numbers? '(1 2 foo 4))
    (all-numbers? '())
    ]}

@defproc[(listof? [pred (-> any? boolean?)] ...+) (-> any? boolean?)]{
  Returns a predicate that returns @racket[#t] for any value that is a list with one
  element for each @racket[pred] whose first element satisfies the first @racket[pred],
  second element satisfies the second @racket[pred], and so on for each @racket[pred].
  @module-examples[
    (define num-sym-num? (listof? number? symbol? number?))
    (num-sym-num? '(1 foo 2))
    (num-sym-num? '(1 2 3))
    (num-sym-num? '(foo bar baz))
    (num-sym-num? '(1 foo))
    (num-sym-num? '(1 foo 2 bar))
    (num-sym-num? 'foo)
    ]}

@defproc[(list-with-head? [pred (-> any? boolean?)] ...+) (-> any? boolean?)]{
  Similar to listof? but returns @racket[#t] for lists with extra elements
  @module-examples[
    (define starts-with-num-sym? (list-with-head? number? symbol?))
    (starts-with-num-sym? '(1 foo 2 3 4 5))
    (starts-with-num-sym? '(1 foo))
    (starts-with-num-sym? '(foo bar baz))
    (starts-with-num-sym? '(1 2 3))
    (starts-with-num-sym? '())
    (starts-with-num-sym? 5)
    ]}

@section{Conditional Combinators}

@defproc[(if? [pred (-> any? boolean?)] [f (-> any? any?)] [g (-> any? any?) identity]) (-> any? any?)]{
  Returns a function that, for an input @racket[v], returns
  @racket[(if (pred v) (f v) (g v))].
  @module-examples[
    (define abs-add1 (if? positive? add1 sub1))
    (abs-add1 4)
    (abs-add1 -4)
    (abs-add1 0)
    ]}

@defproc[(when? [pred (-> any? boolean?)] [f (-> any? any?)]) (-> any? any?)]{
  Returns a function that, for an input @racket[v], returns @racket[(when (pred v) (f v))].
  @module-examples[
    (define displayln-when-even? (when? even? displayln))
    (displayln-when-even? 5)
    (displayln-when-even? 4)
    (displayln-when-even? 10)
    ]}

@defproc[(unless? [pred (-> any? boolean?)] [f (-> any? any?)]) (-> any? any?)]{
  Returns a function that, for an input @racket[v], returns @racket[(unless (pred v) (f v))].
  @module-examples[
    (define displayln-unless-even? (unless? even? displayln))
    (displayln-unless-even? 5)
    (displayln-unless-even? 4)
    (displayln-unless-even? 10)
    ]}

@defproc[(while? [pred (-> any? boolean?)] [f (-> any? any?)]) (-> any? any?)]{
  Returns a function that, for an input @racket[v], returns just @racket[v] if @racket[(p v)]
  is false, otherwise it recursively calls itself with @racket[(f v)].
  @module-examples[
    (define while-negative-add10
      (while? (<? 0) (λ (x) (+ x 10))))
    (while-negative-add10 -7)
    (while-negative-add10 -23)
    (while-negative-add10 15)
    ]}

@defproc[(until? [pred (-> any? boolean?)] [f (-> any? any?)]) (-> any? any?)]{
  Logical inverse of @racket[while?]. Equivalent to @racket[(while? (not? p) f)].
  @module-examples[
    (define until-negative-sub10
      (until? (<? 0) (λ (x) (- x 10))))
    (until-negative-sub10 7)
    (until-negative-sub10 23)
    (until-negative-sub10 -15)
    ]}

@defproc[(do-while? [pred (-> any? boolean?)] [f (-> any? any?)]) (-> any? any?)]{
  Like @racket[while?] except that @racket[f] is guaranteed to be called at least once.
  Similar to the relationship between @code{while} and @code{do ... while} loops in
  imperative languages. Equivalent to @racket[(compose (while? p f) f)].
  @module-examples[
    (define do-while-negative-add10
      (do-while? (<? 0) (λ (x) (+ x 10))))
    (do-while-negative-add10 -7)
    (do-while-negative-add10 -23)
    (do-while-negative-add10 15)
    ]}

@defproc[(do-until? [pred (-> any? boolean?)] [f (-> any? any?)]) (-> any? any?)]{
  Logical inverse of @racket[do-while?]. Equivalent to @racket[(do-while? (not? p) f)].
  @module-examples[
    (define do-until-negative-sub10
      (do-until? (<? 0) (λ (x) (- x 10))))
    (do-until-negative-sub10 7)
    (do-until-negative-sub10 23)
    (do-until-negative-sub10 -15)
    ]}

@section{Miscellaneous}

@defproc[(true? [v any?]) boolean?]{
  Returns @racket[#t] if @racket[v] is not @racket[#f], and @racket[#f] otherwise.
  Useful to turn "truthy" functions into predicates that only return @racket[#t]
  or @racket[#f].
  @module-examples[
    (true? #t)
    (true? #f)
    (true? 'foo)
    ]}

@defproc[(without-truthiness [f proc?]) proc?]{
  Returns a procedure that's like @racket[f], but returns either @racket[#t] or
  @racket[#f] based on whether @racket[f] returns false. Essentially, this procedure
  turns functions that rely on returning "truthy" values into function that only
  return a boolean.
  @module-examples[
    (define member? (without-truthiness member))
    (member? 1 '(1 2 3))
    (member? 'foo '(1 2 3))
]}

@defproc[(in-range? [low real?] [high real?] [exclusive? boolean? #f]) (-> any? boolean?)]{
  Returns a predicate that determins in its input is a real number between @racket[low]
  and @racket[high]. If @racket[exclusive?] is @racket[#t], then values @racket[=] to
  @racket[low] or @racket[high] will return @racket[#f].
  @module-examples[
    (define zero-to-ten? (in-range? 0 10))
    (zero-to-ten? 5)
    (zero-to-ten? 0)
    (zero-to-ten? 10)
    (zero-to-ten? 15)
    (zero-to-ten? -100)
    (define between-zero-and-ten? (in-range? 0 10 #t))
    (between-zero-and-ten? 5)
    (between-zero-and-ten? 0)
    (between-zero-and-ten? 10)
    ]}
