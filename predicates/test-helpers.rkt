#lang racket

(require rackunit)

(provide check-pred-domain
         check-pred-domain*)

(define-check (check-pred-domain p true-input false-input)
  (check-true (p true-input))
  (check-false (p false-input)))

(define-check (check-pred-domain* p true-inputs false-inputs)
  (map (λ (a) (check-true (p a))) true-inputs)
  (map (λ (a) (check-false (p a))) false-inputs))