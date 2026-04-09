*selecciono el directorio que en este caso solo es necesario para exportar el grafico y guardar la base de datos en la parte 6

*cd "C:\Users\Damián\Damian - Facultad\Maestria en Economía\Instrumentos Computacionales\TP1"


*------------------Parte 1------------------

*cargar base de datos (ya se encuentra en stata)
sysuse "auto.dta", clear

*comandos para describir y mostrar datos de las variables
describe

*resumen estadístico general de todas las variables numéricas (make es texto, asi que sus valores son 0)
sum

*estadisticos para las variables de mayor interés
sum price, detail
sum weight, detail

*rep78 tiene menos obs que el resto, eso es porque tiene missings 
tab rep78, m

*vemos estadisticos del precio segun el registro de reparación
tab rep78, summarize(price)

*------------------Parte 2------------------

*se renombra la variable
rename weight peso

*se le asigna etiqueta
label var peso "Peso (libras)"

gen precio_miles = price/1000
label var precio_miles "Precio (miles de USD)"

*se genera variable dummy y las condiciones de cada estado teniendo en cuenta no incluir valores missing
gen pesado = .
replace pesado=1 if peso>3000 & peso!=.
replace pesado=0 if peso<=3000
label var pesado "Pesadez"

*se crea etiqueta para cada estado "tapesao" y se aplica a la variable "pesado"
label define tapesao 0 "Liviano" 1 "Pesado"
label values pesado tapesao


*------------------Parte 3------------------

*eliminar variables
drop headroom trunk

*eliminar observaciones con valores missing en rep78
drop if rep78==.

*ordenar por precio de mayor a menor
gsort - price 


*------------------Parte 4------------------

*tabla con foreig en filas y pesado en las columnas 
table (foreign) (pesado) if price>4000, stat(frequency) stat(percent)

*tabla: dentro de stat() se pone el estadistico y las variables de las cuales se quiere obtener. nformat es para especificar cuantos decimales se quiere para que estadistico y variables
table (foreign) , stat(mean precio_miles peso) stat(sd precio_miles peso) nformat(%12.2f mean precio_miles peso) nformat(%12.1fc sd precio_miles peso)


*------------------Parte 5------------------

twoway scatter precio_miles peso, msymbol(Oh) msize(small) mcolor(teal) mlwidth(medium) title("Precio vs. Peso del vehículo", size(medium) color(dknavy)) xlabel(1000(500)5000, labsize(small) grid glcolor(gs12) glpattern(dot) format(%9.0fc)) ylabel(0(5)20, labsize(small) grid glcolor(gs12) glpattern(dot)) graphregion(color(gs15)) plotregion(color(gs15))


*------------------Parte 6------------------

*exporto el graph a mi directorio con el tamaño que quiero
graph export "scatter_ejercicio1.png", width(2000) replace

*guardo la base modificada
save "auto_modificada.dta", replace





*Fin ᓚᘏᗢ