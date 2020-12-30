#lang racket
;; funciones auxiliares BEGIN

;; (coefficient l i)
;; Genera el elemento número <i> del piso <l> del triangolo de pascal.
;; Retorna un entero.
(define (coefficient l i) ;; para f >= c >= 0
  (cond
    ((= i 0) 1)
    ((> i (ceiling (/ l 2))) (delay (coefficient l (- l i))))
    (else (* (coefficient l (- i 1)) (/ (+ (- l i) 1) i)))
  )
)

;; (randomInRange a b)
;; Genera un entero aleatorio n tal que a <= n <= b.
;; Retorna un entero.
(define (randomInRange a b) ;; a <= return <= b
  (random a (+ 1 b))
)

;; (_getLength i ls)
;; Obtiene el largo de la lista <ls> (Lo va almacenando en <i>).
;; Retorna un entero.
(define (_getLength i ls)
  (if (null? ls)
    i
    (_getLength (+ i 1) (cdr ls))
  )
)

;; (getLength ls)
;; Inicializa _getLength con el valor inicial 0.
;; Retorna un entero.
(define (getLength ls)
  (_getLength 0 ls)
)


;; (slice ls s cnt)
;; Recoje los <cnt> primeros elementos de una lista <ls> a partir del elemento <s>.
;; Retorna una lista.
(define (slice ls s cnt) ;; 0 <= count, 0 <= start < |ls|, count - start <= |ls|
  (cond
    ((= cnt 0) '())
    ((> s 0) (slice (cdr ls) (- s 1) cnt))
    (else (cons (car ls) (slice (cdr ls) 0 (- cnt 1))))
  )
)

;; (removeIndex ls i)
;; Quita de la lista <ls> el elemento en la posición <i>.
;; Retorna una lista.
(define (removeIndex ls i) ;; 0 <= i < |ls|
  (if (= i 0)
    (cdr ls)
    (cons (car ls) (removeIndex (cdr ls) (- i 1)))
  )
)


;; (insertIndex a ls i)
;; Inserta en la posición <i> de la lista <ls> el elemento <a>.
;; Retorna una lista.
(define (insertIndex a ls i) ;; 0 <= i <= |ls|
  (if (= i 0)
    (cons a ls)
    (cons (car ls) (insertIndex a (cdr ls) (- i 1)))
  )
)

;; (replace a ls i)
;; Reemplaza el elemento en la posición <i> de la lista <ls> con el elemento <a>.
;; Retorna una lista.
(define (replace a ls i)
  (insertIndex a (removeIndex ls i) i)
)

;; (getByIndex ls i)
;; Obtiene el elemento en la posición <i> de la lista <ls>.
;; Retorna un elemento de la lista (No sabemos de qué tipo).
(define (getByIndex ls i) ;; 0 <= i < |ls|
  (if (= i 0)
    (car ls)
    (getByIndex (cdr ls) (- i 1))
  )
)

;; (_moedas_rec ls i e)
;; Resuelve el problema 2. <i> y <e> son variables auxiliares para guadar los candidatos a valor más grande.
;; Retorna un entero.
(define (_monedas_rec ls i e)
  (if (null? ls)
    (max e i)
    (_monedas_rec (cdr ls) (+ e (car ls)) (max e i))
  )
)

;; (getPreorder t)
;; Obtiene una lista con todas las hojas del arbol <t> en preorden.
;; Retorna una lista.
(define (getPreorder t)
  (if (null? t)
    '()
    (append (list (car t))
      (getPreorder (cadr t))
      (getPreorder (caddr t))
    )
  )
)

;; (floatRemainder n m)
;; Obtiene el resto de una división entre los números flotantes <n> y <m>.
;; Retorna un flotante.
(define (floatRemainder n m)
  (- n (* (truncate (/ n m)) m))
)

;; (modulo a b)
;; Realiza la operación <a>%<b>.
;; Retorna un número, puede ser entero o flotante.
(define (modulo a b)
  (let ((res (floatRemainder a b)))
    (if (< b 0)
      (if (<= res 0) res (+ res b))
      (if (>= res 0) res (+ res b))
    )
  )
)

;; (factorial n)
;; Realiza la operación <n>!.
;; Retorna un entero.
(define factorial
  (lambda (n)
    (let fact ((i n) (a 1) )
      (if (= i 0)
        a
        (fact (- i 1) (* a i))
      )
    )
  )
)
;; END funciones auxiliares

(define (lazypascal n)
  (do ((i 0 (+ i 1)) (ls '() (insertIndex (force (coefficient n i)) ls i)))
    ((> i n) ls)
  )
)

(define (monedas_iter l1)
  (do ((ls l1 (cdr ls)) (i 0 (+ e (car ls))) (e 0 (max e i)))
    ((null? ls) (max e i))
  )
)

(define (monedas_rec l1)
  (_monedas_rec l1 0 0)
)

(define (crossrd l1 l2) ;; |l1| == |l2|
  (letrec ((len (getLength l1)) (cut (randomInRange 0 len)) (cnt (- (randomInRange cut len) cut)))
    (display "Cortes en ")
    (display cut)
    (display " y ")
    (display (+ cut cnt))
    (display ". La notación de los cortes está disponible en la documentación\n")
    (let ((sl1 (slice l1 cut cnt)) (sl2 (slice l2 cut cnt)))
      (list
        (do ((_cnt cnt (- _cnt 1)) (ls l1 (replace (getByIndex sl2 (- _cnt 1)) ls (- (+ cut _cnt) 1))))
          ((= _cnt 0) ls)
        )
        (do ((_cnt cnt (- _cnt 1)) (ls l2 (replace (getByIndex sl1 (- _cnt 1)) ls (- (+ cut _cnt) 1))))
          ((= _cnt 0) ls)
        )
      )
    )
  )
)

(define (preorden arbol funcion)
  (apply funcion (getPreorder arbol))
)

(define seno
  (lambda (x)
    (display "La función posee un error de ±0,00016 (Véase la documentación)\n")
    (let* (;; Lo que hago es poner x en el rango [0, 2π], luego si x \in [π/2, 3π/3] entonces reflejo x y cambio el signo Ej: (sen(3π/4) = -sen(-π/4))
      (x (modulo x (* 2 pi)))
      (s (cond
            ((> x (* 1.5 pi)) 1)
            ((> x (/ pi 2)) -1)
            (else 1)
          )
        )
        (x (cond
            ((> x (* 1.5 pi)) (- x (* 2 pi)))
            ((> x (/ pi 2)) (- x pi))
            (else x)
          )
        )
      )
      (let sen ((n 0) (b 0))
        (if (> n 3)
          b
          (sen
            (+ n 1)
            (+ b (/ (* s (expt -1 n) (expt x (+ (* 2 n) 1))) (factorial (+ (* 2 n) 1))))
          )
        )
      )
    )
  )
)