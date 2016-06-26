#lang info

(define collection 'multi)
(define deps '("base" "rackunit-lib"))
(define build-deps '("scribble-lib"
                     "rackunit-lib"
                     "racket-doc"))

(define cover-omit-paths
  '(#rx".*\\.scrbl"
    #rx"info\\.rkt"
    ))
