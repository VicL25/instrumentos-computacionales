# Trabajo Práctico 2

## Objetivo

Practicar organización e integración de bases, transformación de estructuras, construcción de indicadores, elaboración y exportación de tablas.

## Archivos disponibles

En la carpeta `bases/` pueden encontrar los siguientes archivos:

- `comercios.xlsx`
- `precios.dta`
- `productos.dta`

> [!important]
>  Sugerencia: abrir cada archivo para familiarizarse con su estructura y contenido antes de comenzar a trabajar.

## Entrega
> [!important]
> Debe enviarse al mail santiagocerutti1@gmail.com antes de la próxima clase (21/4).

## Consigna

Crear un do-file que resuelva los siguientes puntos.

1. Importar `comercios.xlsx`, hacer las modificaciones necesarias para su posterior uso y guardar esa base temporalmente.
2. Cargar `precios.dta` y unir la información de `productos.dta`.
   - Conservar solo las observaciones con correspondencia en ambas bases.
3. Agregar la información de comercios (comercio y bandera).
   - Conservar solo las observaciones con match.
4. Generar una variable numérica de identificación única para cada bandera llamada `store`.
5. Modificar la estructura de la base para que el precio de cada año quede en variables separadas, dejando como unidad de análisis `producto-store`.
6. Crear una variable de variación porcentual del precio entre 2025 y 2024.
7. Crear una variable indicadora que tome valor 1 cuando el producto subió de precio y 0 cuando no subió.
8. Mostrar cuántos productos subieron y cuántos no subieron por `store`.
9. Mostrar qué productos mantuvieron el mismo precio entre 2024 y 2025.
10. Construir una tabla con el promedio y desvío estándar de la variación de precio por `store`.
11. Construir tres tablas de variación promedio del precio por `store`, desagregadas por:
    - `rubro`
    - `categoria`
    - `subcategoria`
12. Exportar esas tres tablas a un único archivo Excel llamado `tp2.xlsx`, en tres pestañas independientes con los nombres:
    - `rubro`
    - `categoria`
    - `subcategoria`
13. Resolver el punto de anterior usando un bucle (`foreach`).

> [!important]
>  El do-file debe correr de principio a fin, donde la única modificación necesaria sea la definición de las rutas al comienzo del mismo.

