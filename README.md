predicates
==========

A racket package for creating predicates in a point-free style

    (define symbol-or-string? (or? symbol? string?))
    (symbol-or-string? 'blah) ; true
    (symbol-or-string? "foo") ; true
    (symbol-or-string? 8) ; false
    
    (define even-number? (and? number? even?))
    (even-number? 6) ; true
    (even-number? 9) ; false
    (even-number? 'foo) ; false
    
    (define not-symbol? (not? symbol?))
    (not-symbol? 1) ; true
    (not-symbol? 'bar) ; false
