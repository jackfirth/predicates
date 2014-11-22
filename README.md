predicates
==========

A racket package for creating predicates in a point-free style

    (filter (or? symbol? string?) '(1 a 3 "blah" b 4 5))
    -> '(a "blah" b)
    
    (filter (and? number? even?) '(a b 2 5 6 "foo" bar 9 8))
    -> '(2 6 8)
    
    (filter (not? symbol?) '(a b 2 3 "baz" d))
    -> '(2 3 "baz")
