#lang scribble/manual

@(require "predicates.rkt")

@title{Predicates}
@defmodule[predicates]

These functions allow for easy construction of @italic{predicates} - functions that take an input and return a boolean - for
use with contracts and @racket[filter] variants. This library makes it easy to define predicates in a @italic{point-free} style,
meaning that you can construct new predicates in terms of old predicates without defining them as functions with arguments.

@section{Logic Predicate Constructors}

@defproc[(and? [pred (-> any? boolean?)] ...+) (-> any? boolean?)]{
Combines each @racket[pred] into a single predicate that returns @racket[#t] for its if all the original @racket[pred]s
return @racket[#t] for the input.
}

@defproc[(or? [pred (-> any? boolean?)] ...+) (-> any? boolean?)]{
Combines each @racket[pred] into a single predicate that returns @racket[#t] for its input if any of the original @racket[pred]s
return @racket[#t] for the input.
}

@defproc[(not? [pred (-> any? boolean?)]) (-> any? boolean?)]{
Returns a new predicate that returns @racket[#t] for its input if the original predicate returns @racket[#f] for the input.
}

@defproc[(and?* [pred (-> any? boolean?)] ...+) (->* () () #:rest any? boolean?)]{
Combines each @racket[pred] into a single function that accepts any number of arguments and returns @racket[#t] if the first
@racket[pred] returns @racket[#t] for the first argument, and the second @racket[pred] returns @racket[#t] for the second
argument, and so on for each @racket[pred] and each argument.
}

@defproc[(or?* [pred (-> any? boolean?)] ...+) (->* () () #:rest any? boolean?)]{
Combines each @racket[pred] into a single function in a manner similar to @racket[and?*], except the resulting function returns
@racket[#t] if any of the @racket[pred]s return @racket[#t] for their argument.
}

@section{Comparison Predicate Constructors}

@defproc[(eq?? [v any?]) (-> any? boolean?)]{
Returns a predicate that returns @racket[#t] for any input that is @racket[eq?] to @racket[v].
}

@defproc[(eqv?? [v any?]) (-> any? boolean?)]{
Returns a predicate that returns @racket[#t] for any input that is @racket[eqv?] to @racket[v].
}

@defproc[(equal?? [v any?]) (-> any? boolean?)]{
Returns a predicate that returns @racket[#t] for any input that is @racket[equal?] to @racket[v].
}

@defproc[(=? [v any?]) (-> any? boolean?)]{
Returns a predicate that returns @racket[#t] for any input that is @racket[=] to @racket[v].
}

@defproc[(<? [v real?]) (-> real? boolean?)]{
Returns a predicate that returns @racket[#t] for any real input that is @racket[<] than @racket[v].
}

@defproc[(>? [v real?]) (-> real? boolean?)]{
Returns a predicate that returns @racket[#t] for any real input that is @racket[>] than @racket[v].
}

@defproc[(<=? [v real?]) (-> real? boolean?)]{
Returns a predicate that returns @racket[#t] for any real input that is @racket[<=] to @racket[v].
}

@defproc[(>=? [v real?]) (-> real? boolean?)]{
Returns a predicate that returns @racket[#t] for any real input that is @racket[>=] to @racket[v].
}

@section{List Predicate Constructors}

@deftogether[(@defproc[(first? [pred (-> any? boolean?)] ...+) (-> list? boolean?)]
              @defproc[(second? [pred (-> any? boolean?)] ...+) (-> list? boolean?)]
              @defproc[(third? [pred (-> any? boolean?)] ...+) (-> list? boolean?)]
              @defproc[(fourth? [pred (-> any? boolean?)] ...+) (-> list? boolean?)])]{
Returns a predicate that returns @racket[#t] for any list whose first, second, third, or fourth item satisfies
@racket[(and? pred ...)], depending on the procedure chosen.
}

@defproc[(rest? [pred (-> any? boolean?)]) (-> list? boolean?)]{
Returns a predicate that returns @racket[#t] for any list for which the @racket[rest] of the list satisfies @racket[pred].
}

@defproc[(all? [pred (-> any? boolean?)]) (-> list? boolean?)]{
Returns a predicate that returns @racket[#t] for any list for which every element in the list satisfies @racket[pred].
}

@defproc[(listof? [pred (-> any? boolean?)] ...+) (-> list? boolean?)]{
Returns a predicate that returns @racket[#t] for any list for which the first element of the list satisfies the
first @racket[pred], the second element satisfies the second @racket[pred], and so on for each @racket[pred].
}

@section{Common List Predicates}

@defproc[(not-null? [v any?]) boolean?]{
Returns @racket[#t] if @racket[v] is @racket[null?], and returns @racket[#f] otherwise. Equivalent to @racket[(not? null?)].
}

@defproc[(nonempty-list? [v any?]) boolean?]{
Returns @racket[#t] if @racket[v] is a list containing at least one element, and returns @racket[#f] otherwise.
Equivalent to @racket[(and? list? (not? null?))].
}

@defproc[(nonsingular-list? [v any?]) boolean?]{
Returns @racket[#t] if @racket[v] is a list containing at least two elements, and returns @racket[#f] otherwise.
Equivalent to @racket[(and? list? (not? null?) (rest? (not? null?)))].
}

@section{Conditional Combinators}

@defproc[(if? [pred (-> any? boolean?)] [f (-> any? any?)] [g (-> any? any?) identity]) (-> any? any?)]{
Returns a function that, for an input @racket[v], returns @racket[(if (pred v) (f v) (g v))].
}

@defproc[(when? [pred (-> any? boolean?)] [f (-> any? any?)]) (-> any? any?)]{
Returns a function that, for an input @racket[v], returns @racket[(when (pred v) (f v))].
}

@defproc[(unless? [pred (-> any? boolean?)] [f (-> any? any?)]) (-> any? any?)]{
Returns a function that, for an input @racket[v], returns @racket[(unless (pred v) (f v))].
}

@section{Miscellaneous}

@defproc[(true? [v any?]) boolean?]{
Returns @racket[#t] if @racket[v] is not @racket[#f], and @racket[#f] otherwise. Useful to turn "truthy" functions into predicates that
only return @racket[#t] or @racket[#f].
}

@defproc[(in-range? [low real?] [high real?] [exclusive? boolean? #f]) (-> any? boolean?)]{
Returns a predicate that determins in its input is a real number between @racket[low] and @racket[high]. If @racket[exclusive?]
is @racket[#t], then values @racket[=] to @racket[low] or @racket[high] will return @racket[#f].
}