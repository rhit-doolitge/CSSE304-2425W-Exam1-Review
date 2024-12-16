#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "testcode-base.rkt")
(require "Exam1-Review-Problems.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)
              (double equal? ; (run test double)
                      [(double '(1 2 3)) '(2 4 6) 1]
                      [(double '(-1 0 1)) '(-2 0 2) 1]
                      [(double '()) '() 1]                   ; Empty list
                      [(double '(5 10 15)) '(10 20 30) 1]    ; Multiples of 5
                      [(double '(1)) '(2) 1]                 ; Single element
                      [(double '(100 -50 25)) '(200 -100 50) 1])

              (make-decreasing equal?
                               [(make-decreasing '(7 5 9 3 2 5 9 6 5 1)) '(7 5 3 2 1) 1]
                               [(make-decreasing '(1 2 3 4)) '(1) 1]                ; Already increasing
                               [(make-decreasing '()) '() 1]                         ; Empty list
                               [(make-decreasing '(10 9 8 7)) '(10 9 8 7) 1]        ; Already decreasing
                               [(make-decreasing '(10 5 10 3 1)) '(10 5 3 1) 1]     ; Mixed
                               [(make-decreasing '(5 5 5 5)) '(5) 1])               ; All elements equal

              (remove-symbols equal?
                              [(remove-symbols '(1 5 3 f 7 w 48)) '(1 5 3 7 48) 1]
                              [(remove-symbols '(a b c)) '() 1]                    ; Only symbols
                              [(remove-symbols '()) '() 1]                         ; Empty list
                              [(remove-symbols '(1 2 3 4)) '(1 2 3 4) 1]           ; No symbols
                              [(remove-symbols '(1 f 2)) '(1 2) 1]                 ; Mixed symbols
                              [(remove-symbols '(x 5 y 7 z)) '(5 7) 1])

              (remove-instances-of equal?
                                     [(remove-instances-of 2 '(1 2 3 4 2)) '(1 3 4) 1]
                                     [(remove-instances-of 5 '(5 5 5 5)) '() 1]       ; All elements removed
                                     [(remove-instances-of 0 '(1 2 3)) '(1 2 3) 1]    ; No removal
                                     [(remove-instances-of 4 '()) '() 1]              ; Empty list
                                     [(remove-instances-of 3 '(3 3 3 1 2 3)) '(1 2) 1]
                                     [(remove-instances-of -1 '(-1 0 -1 2)) '(0 2) 1])

              (count-occurences equal?
                                  [(count-occurences 2 '(1 2 3 4 2 2)) 3 1]
                                  [(count-occurences 5 '(5 5 5 5)) 4 1]               ; All elements match
                                  [(count-occurences 0 '(1 2 3)) 0 1]                ; No matches
                                  [(count-occurences 3 '()) 0 1]                     ; Empty list
                                  [(count-occurences 3 '(3 3 3 1 2 3)) 4 1]
                                  [(count-occurences -1 '(-1 0 -1 2)) 2 1])

              (insert-sorted equal?
                               [(insert-sorted 4 '(1 2 3 5 6)) '(1 2 3 4 5 6) 1]
                               [(insert-sorted 0 '(1 2 3)) '(0 1 2 3) 1]             ; Insert at start
                               [(insert-sorted 5 '(1 2 3)) '(1 2 3 5) 1]             ; Insert at end
                               [(insert-sorted 3 '()) '(3) 1]                        ; Empty list
                               [(insert-sorted 2 '(2 2 2)) '(2 2 2 2) 1]             ; All elements equal
                               [(insert-sorted -1 '(-3 -2 0)) '(-3 -2 -1 0) 1])      ; Negative values

              (make-max-list equal?
                              [(make-max-list '(1 2 3 4) '(4 3 1 2)) '(4 3 3 4) 1]
                              [(make-max-list '(1 2 3) '(3 4)) '(3 4 3) 1]           ; First list longer
                              [(make-max-list '(1 2) '(3 4 5)) '(3 4 5) 1]           ; Second list longer
                              [(make-max-list '(1 2 3) '(3 4 5)) '(3 4 5) 1]         ; All larger in second list
                              [(make-max-list '(5 6 7) '(1 2)) '(5 6 7) 1]           ; First list dominates
                              [(make-max-list '() '()) '() 1])                        ; Empty lists

              (expand-ranges equal?
                           [(expand-ranges '((1 3) (10 14))) '(1 2 3 10 11 12 13 14) 1]
                           [(expand-ranges '((5 7) (8 10))) '(5 6 7 8 9 10) 1]
                           [(expand-ranges '((1 1) (2 2))) '(1 2) 1]                ; Single element ranges
                           [(expand-ranges '((3 5) (6 8))) '(3 4 5 6 7 8) 1]        ; Consecutive ranges
                           [(expand-ranges '((0 0) (4 5))) '(0 4 5) 1]              ; Disjoint ranges
                           [(expand-ranges '()) '() 1])

              (expand-symbols equal?
                              [(expand-symbols '((4 a) (2 b))) '(a a a a b b) 1]
                              [(expand-symbols '((0 c) (3 d))) '(d d d) 1]          ; Zero count
                              [(expand-symbols '()) '() 1]                          ; Empty input
                              [(expand-symbols '((1 x) (1 y))) '(x y) 1]            ; Single instance
                              [(expand-symbols '((2 a) (2 b) (2 c))) '(a a b b c c) 1]
                              [(expand-symbols '((1 z) (3 y))) '(z y y y) 1])

              (multiply-by-index equal?
                                 [(multiply-by-index '(3 5 7 23)) '(0 5 14 69) 1]
                                 [(multiply-by-index '(1 2 3)) '(0 2 6) 1]         ; Basic case
                                 [(multiply-by-index '()) '() 1]                   ; Empty list
                                 [(multiply-by-index '(0 0 0)) '(0 0 0) 1]         ; All zeros
                                 [(multiply-by-index '(-1 -2 -3)) '(0 -2 -6) 1]    ; Negative numbers
                                 [(multiply-by-index '(1)) '(0) 1])                ; Single element

              (flatten-list equal?
                            [(flatten-list '(1 4 6 ((5 2) 7 3))) '(1 4 6 5 2 7 3) 1]
                            [(flatten-list '(1 (2 (3 (4))))) '(1 2 3 4) 1]          ; Deeply nested
                            [(flatten-list '()) '() 1]                              ; Empty input
                            [(flatten-list '(5)) '(5) 1]                            ; Single element
                            [(flatten-list '(1 (2 3) (4 (5)))) '(1 2 3 4 5) 1]
                            [(flatten-list '((1 2) ((3)) 4)) '(1 2 3 4) 1])

              (max-depth equal?
                         [(max-depth '(1 4 6 ((5 2) 7 3))) 3 1]
                         [(max-depth '(1 (2 (3 (4))))) 4 1]                         ; Deeply nested
                         [(max-depth '()) 1 1]                                      ; Empty input
                         [(max-depth '(5)) 1 1]                                    ; Single element
                         [(max-depth '(1 (2 3) (4 (5)))) 3 1]
                         [(max-depth '((1 2) ((3)) 4)) 3 1])

              (sum-deep equal?
                        [(sum-deep '(1 4 6 ((5 2) 7 3))) 28 1]
                        [(sum-deep '(1 (2 (3 (4))))) 10 1]                          ; Deeply nested
                        [(sum-deep '()) 0 1]                                       ; Empty input
                        [(sum-deep '(5)) 5 1]                                      ; Single element
                        [(sum-deep '(1 (2 3) (4 (5)))) 15 1]
                        [(sum-deep '((1 2) ((3)) 4)) 10 1])

              (curried-cons equal?
                             [((curried-cons '(2 3 4 5 6)) 1) '(1 2 3 4 5 6) 1]
                             [((curried-cons '()) 1) '(1) 1]                        ; Empty list
                             [((curried-cons '(1)) 0) '(0 1) 1]                     ; Single element
                             [((curried-cons '(2 3)) -1) '(-1 2 3) 1]
                             [((curried-cons '(5 6)) 7) '(7 5 6) 1]
                             [((curried-cons '(x y)) 'z) '(z x y) 1])

              (curried-remove equal?
                              [((curried-remove '(2 3 4 5 6)) 4) '(2 3 5 6) 1]
                              [((curried-remove '()) 4) '() 1]                       ; Empty list
                              [((curried-remove '(1)) 1) '() 1]                     ; Single element
                              [((curried-remove '(2 2 2)) 2) '() 1]                 ; All elements removed
                              [((curried-remove '(1 2 3)) 4) '(1 2 3) 1]            ; No removal
                              [((curried-remove '(x y z)) 'x) '(y z) 1])

              (curried-list-check equal?
                                  [((curried-list-check '(2 4 4 5 4)) 4) 3 1]
                                  [((curried-list-check '()) 4) 0 1]                ; Empty list
                                  [((curried-list-check '(1)) 1) 1 1]               ; Single element
                                  [((curried-list-check '(1 1 1)) 2) 0 1]           ; No matches
                                  [((curried-list-check '(1 2 3)) 2) 1 1]           ; One match
                                  [((curried-list-check '(5 5 5 5)) 5) 4 1])        ; All elements match

              (square-each-then-sum equal?
                                   [(square-each-then-sum '(1 2 3)) 14 1]
                                   [(square-each-then-sum '()) 0 1]                  ; Empty list
                                   [(square-each-then-sum '(0 0 0)) 0 1]             ; All zeros
                                   [(square-each-then-sum '(-1 -2 -3)) 14 1]         ; Negative numbers
                                   [(square-each-then-sum '(1)) 1 1]                 ; Single element
                                   [(square-each-then-sum '(10 20)) 500 1])          ; Larger numbers

              (total-sum equal?
                         [(total-sum '((1 4 5) (3 5 7))) 25 1]
                         [(total-sum '()) 0 1]                                     ; Empty list
                         [(total-sum '((0 0) (0 0))) 0 1]                          ; All zeros
                         [(total-sum '((1) (2) (3))) 6 1]                          ; Single elements
                         [(total-sum '((10 20) (30 40))) 100 1]                    ; Larger numbers
                         [(total-sum '((-1 -2) (-3 -4))) -10 1])                   ; Negative numbers

              (pipeline-creator equal?
                                [(let ((pipeline (pipeline-creator (list (lambda (x) (+ x 1))
                                                                     (lambda (x) (* x 2))))))
                                   (pipeline 3)) 8 1]
                                [(let ((pipeline (pipeline-creator (list (lambda (x) (* x x))
                                                                     (lambda (x) (+ x 3))))))
                                   (pipeline 2)) 7 1]
                                [(let ((pipeline (pipeline-creator '())))
                                   (pipeline 10)) 10 1]                            ; Empty pipeline
                                [(let ((pipeline (pipeline-creator (list (lambda (x) (+ x 2))
                                                                     (lambda (x) (/ x 2))))))
                                   (pipeline 8)) 5 1]
                                [(let ((pipeline (pipeline-creator (list (lambda (x) (- x 3))
                                                                     (lambda (x) (* x -1))))))
                                   (pipeline 6)) -3 1])

              (recurs-factory equal?
                               [(let ((my-fac (recurs-factory 1 *)))
                                  (map my-fac '(1 2 3 4))) '(1 2 6 24) 1]
                               [(let ((my-even? (recurs-factory #t (lambda (n agg) (not agg)))))
                                  (map my-even? '(1 2 3 4 33 34))) '(#f #t #f #t #f #t) 1]
                               [(let ((sum-squares (recurs-factory 0 (lambda (n agg) (+ (* n n) agg)))))
                                  (map sum-squares '(0 1 2 3 6))) '(0 1 5 14 91) 1]
                               )
                                               

              ))

(implicit-run test) ; run tests as soon as this file is loaded
