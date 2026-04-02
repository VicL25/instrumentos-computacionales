# Ejercicio 1

## Objetivo

Practicar los contenidos vistos en la primera clase y familiarizarse con la creación de do-files.

## Tarea

Crear un do-file que realice las siguientes tareas usando la base de datos `auto.dta` incluida en Stata.

## Entrega

Debe enviarse al mail santiagocerutti1@gmail.com antes de la próxima clase (14/7).

## Importante

El código debe poder ejecutarse por completo desde cualquier PC, incluso si ya fue ejecutado previamente. Se valorará la prolijidad y el uso de comentarios adecuados.

------------------------------------------------------------------------

## Parte 1: Carga y exploración

1.  Cargar la base de datos `auto.dta`.
2.  Explorar la base: ¿cuántas observaciones y variables tiene?
3.  Obtener un resumen estadístico general de todas las **variables numéricas**.

------------------------------------------------------------------------

## Parte 2: Variables y etiquetas

4.  Renombrar la variable `weight` a `peso` y asignarle la etiqueta "Peso (libras)".
5.  Crear una variable `precio_miles` que contenga el precio dividido por 1000. Asignarle la etiqueta "Precio (miles de USD)".
6.  Crear una variable `pesado` que valga 1 si el peso es mayor a 3000 libras y 0 en caso contrario. Asignarle la etiqueta "Vehículo pesado".
7.  Definir etiquetas de valores para `pesado`: 0 → "Liviano", 1 → "Pesado". Asignarlas a la variable.

------------------------------------------------------------------------

## Parte 3: Limpieza y ordenamiento

8.  Eliminar las variables `headroom` y `trunk`.
9.  Eliminar las observaciones cuya variable `rep78` sea missing.
10. Ordenar la base por `precio` de mayor a menor.

------------------------------------------------------------------------

## Parte 4: Estadísticas descriptivas

11. Crear una tabla que muestre, entre los autos con precio mayor a 4000, la cantidad y el porcentaje de autos nacionales y extranjeros según sean livianos o pesados.
12. Crear una tabla que muestre, según el origen del auto, el promedio y el desvío estándar de `precio_miles` y `peso`. Intentar replicar exactamente el siguiente formato:

```
    -------------------------------------------------------------------------------------------
               |                   Mean                             Standard deviation         
               |  Precio (miles de USD)   Peso (libras)   Precio (miles de USD)   Peso (libras)
    -----------+-------------------------------------------------------------------------------
    Car origin |                                                                               
      Domestic |                   6.18        3,368.33                     3.2           688.0
      Foreign  |                   6.07        2,263.33                     2.2           364.7
      Total    |                   6.15        3,032.03                     2.9           792.9
    -------------------------------------------------------------------------------------------

```
## Parte 5: Gráfico

13. Replicar el gráfico de dispersión (`scatter`) de `precio_miles` contra `peso` respetando el estilo lo máximo posible.
    ![Gráfico de dispersión](scatter_autos.png)

------------------------------------------------------------------------

## Parte 6: Exportación

14. Exportar el gráfico de dispersión a un archivo PNG con el nombre `scatter_ejercicio1.png`.
15. Guardar la base de datos modificada con el nombre `auto_modificada.dta`.
