# Ejercicio A

## Objetivo

Practicar los contenidos de la primera clase y comparar los códigos entre sí para identificar buenas prácticas y estilos de escritura de código.

## Tarea

Crear un do-file que realice las siguientes tareas usando la base precargada en
Stata: `lifeexp.dta`.

## Entrega

Subir la resolución mediante un fork y Pull Request al repositorio de
GitHub de la materia:
https://github.com/santiagocerutti/instrumentos-computacionales/ejercicios/opcionales/ejercicio-A

Nombre sugerido del archivo: `A-nombre_apellido.do`.

No hay fecha de entrega.

## Importante

El código debe poder ejecutarse por completo desde cualquier PC, incluso
si ya fue ejecutado previamente.

------------------------------------------------------------------------

## Parte 1: Carga y exploración

1. Cargar la base de datos `lifeexp.dta`.

2. Explorar la base: ¿cuántas observaciones y variables tiene?

3. Obtener un resumen estadístico general de las variables numéricas.

------------------------------------------------------------------------

## Parte 2: Variables y etiquetas

4. Renombrar `lexp` a `life_exp`, `gnppc` a `gnp_pc`, `popgrowth` a `pop_growth` y `safewater` a `safe_water`.

5. Asignar etiquetas a las variables:
```
----------------------------------------------------
| country    |"País"
| pop_growth |"Tasa de crecimiento anual promedio"
| life_exp   |"Esperanza de vida"
| gnp_pc     |"Ingreso per capita (USD)"
| safe_water |"Población con acceso a agua segura (%)"
| region     |"Región"
-----------------------------------------------------
```

6. Crear una variable categórica de ingreso bajo, medio-bajo, medio-alto y alto. Usando como referencia los
   cortes: 1100, 4500 y 14000 dólares per capita. Asignarle etiqueta de variable `"Categoria de ingreso"` y etiquetas de valores.

7. Crear una dummy `cobertura_alta` que valga 1 si `safe_water` es al menos 80 y 0 si es menor a 80. Asignarle etiqueta de variable `"Cobertura de agua segura"` y etiquetas de valores `"Baja"` y `"Alta"`.

------------------------------------------------------------------------

## Parte 3: Limpieza y ordenamiento

8. Eliminar las observaciones sin dato en `safe_water` y la correspondiente a `"Yugoslavia"`.

9. Mostrar los 10 países con mayor esperanza de vida.

------------------------------------------------------------------------

## Parte 4: Estadísticas descriptivas

10. Obtener media, mediana, desvío estándar, mínimo y máximo de `life_exp`, `safe_water` e `ingreso_miles`.

11. Crear una tabla que muestre los ingresos per cápita promedios según `region`.

12. Obtener la media de esperanza_vida segun categoria de ingreso. Intentar replicar la tabla con este formato:
```
-------------------------------------------------------------------------------
                     |  Mean   Standard deviation   Number of nonmissing values
---------------------+---------------------------------------------------------
Categoria de ingreso |                                                         
  Bajo               |  66.2                  5.3                             9
  Medio-bajo         |  70.3                  2.8                            13
  Medio-alto         |  73.1                  2.6                             8
  Alto               |  78.0                  0.8                             7
  Total              |  71.4                  5.2                            37
-------------------------------------------------------------------------------
```
13.  Crear una tabla que muestre, segun la categoria de agua segura, el promedio, el desvio estandar y el maximo de esperanza_vida. Intentar replicar la tabla con este formato:
```
--------------------------------------------------
                   |    Cobertura de agua segura  
                   |     Baja      Alta      Total
-------------------+------------------------------
Mean               |     68.5      74.7       71.5
Standard deviation |      4.6       3.6        5.1
Maximum value      |       75        79         79
--------------------------------------------------
```

14. Crear una tabla que muestre, entre los países con `gnp_pc` menor a 4000, la cantidad y el porcentaje por fila de países con cobertura baja y alta de agua segura según región.

------------------------------------------------------------------------

## Parte 5: Gráficos

15. Replicar un gráfico de dispersión (`scatter`) de `life_exp` contra
    `safe_water` respetando un estilo prolijo.

