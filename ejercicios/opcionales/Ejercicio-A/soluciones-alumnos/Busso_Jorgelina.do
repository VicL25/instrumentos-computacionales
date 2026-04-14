**************************
*TP1 Instrumentos computacionales
*Busso Jorgelina
**************************

clear all
set more off

* 1 cargar base de datos 
sysuse auto, clear

* 2 inspección de los datos
describe

* 3 resumen estadistico general
summarize

* 4 renombrar variable
rename weight peso
* asignar etiqueta
label variable peso "Peso (libras)"

*5 crear variable 
gen precio_miles = price/1000
*etiqueta
label variable precio_miles "Precio (miles de USD)"

*6 crear variable 
gen pesado = . 
replace pesado = 1 if peso > 3000
replace pesado = 0 if peso <= 3000
*etiqueta
label variable pesado "Vehículo pesado"

*7 definir etiquetas
label define pesado_label 0 "Liviano" 1 "Pesado"
label values pesado pesado_label

*8 eliminar variable
drop headroom
drop trunk

*9 eliminar observaciones
drop if missing(rep78)

*10 ordenar base de datos precio descendente
gsort -price, generate(orden_precio) mfirst

*11 tabla nacionales-extranjeros mayores a 4000
tabulate pesado foreign if price > 4000, row col

*12 tabla nacionales-extranjeros precio y peso  
table foreign, c(mean price mean peso sd price sd peso) 

*13 scatter
graph twoway (scatter precio_miles peso, ///
 msymbol(Oh) mcolor(teal) mlcolor(teal) msize(small)), ///
 title("Precio vs. Peso del vehículo") ///
 xtitle("Peso (libras)") ///
 ytitle("Precio (miles de USD)") ///
 graphregion(color(white)) ///
 plotregion(color(white)) ///
 xlabel(1000(500)5000, grid) ///
 ylabel(0(5)20, grid) ///
 legend(off) ///
 scheme(s1color) 

*14 exportar scatter
graph export "scatter_ejercicio1.png" , replace

*15 guardar base de datos modficada
save auto_modificada.dta, replace



