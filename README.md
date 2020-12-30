# Integrantes
Zarko Kuljis, 201823523-7

Obtuve un 100.
# Uso
## Cortes
Séa una lista de elementos cualquiera de largo n se definen sus cortes posibles con numeros 0..n+1, donde cada número corresponde a cortar entre el elemento en esa posición y el anterior.

Ej: Séa la lista '(0 1 2):
* Corte en 0: '(|0 1 2)
* Corte en 1: '(0|1 2)
* Corte en 2: '(0 1|2)
* Corte en 3: '(0 1 2|)

Ej: Séa la lista '(0 1 2 3 4) y se desea obtener la sección entre los cortes 1 y 3:
* '(0|1 2|3 4) = '(1 2)
# Consideraciones
## crossrd
* Dos cortes pueden suceder en el mismo punto, es decir, puede darse el caso de que la lista '(0 1 2 3) sea cortada en 2 y 2, obteniendo la sección entre los cortes igual a '().
## seno
La función seno se puede aproximar mediante la serie de taylor:

![](/taylor.png)

Sabemos que, para una aproximación en un punto por serie de Taylor, el error crece mientras más te alejas de el pivote (En nuestro caso 0) y se comporta de forma estrictamente creciente. Ahora, conociendo que la serie de taylor de tercer grado de la función seno nos da un error de 0.00016 para x = 90 (calculado mediante abs(sen(x)-taylorSeno(x))), siendo el pivote 0, podemos afirmar que el máximo error de la aproximación de Taylor del seno en el intervalo [-π/2,π/2], con grado 3, es de ±0.00016.

Ya que se nos pide una presición del 0.001, abarcando la sumatoria desde n=0 hasta n=3 basta.

Ahora, ¿Qué pasa con el resto del intervalo, es decir [π/2, 3π/3]? Bueno, aprovechandonos de que la función seno es impar y periodica, podemos decir simplemente tomar el valor del coseno del angulo opuesto (es decir, restar π) y multiplicarlo por -1.

Fuente: https://www.ck12.org/book/ck-12-conceptos-de-c%c3%a1lculo-en-espa%c3%b1ol/section/9.16/