clear all
set more off

*Asignamos la ruta donde se encuentran las bases
cd "D:\Users\Antonio\Desktop\cosas\WORDS\Facultad\6to año\Seminario datos computacionales\Stata\TP'S\Adicionales\Adicionales-B\Bases adicionales B"

*----------------------------------------------------Punto 1----------------------------------------------------
*Importamos el excel de comercio agregando la opción first así se conservan los nombres de las variables en la primera fila
import excel "comercios.xlsx", clear first

*inspeccionamos la base y vemos si le tenemos que camibar el nombre o el tipo a ciertas variables para que sean exactamente iguales al del resto de dataset, para luego poder hacer el merge tranquilamente.
*En este caso no es necesario hacer nada, el nombre y tipo coincide. 


*Como la base debe usarse más adelante y la consigna pide guardarla como temporal, la almacenamos en un archivo temporal
tempfile comercios
save `comercios' , replace

*----------------------------------------------------Punto 2----------------------------------------------------

* Unimos las 12 bases mensuales mediante un bucle. Se utiliza append porque cada archivo contiene las mismas variables, pero distintas observaciones correspondientes a cada mes. Por lo tanto, corresponde unir las bases por filas y no por columnas.

*Abrimos primero una base, para que funcione como máster
use "precios_01.dta", clear

*Hacemos el bucle 


forvalues i = 2/12 {
	* Se define la local "mes" con formato de dos dígitos para que coincida con los nombres de los archivos (02,03 ..., 12).
	local mes : display %02.0f `i'
    append using precios_`mes'.dta
}


*----------------------------------------------------Punto 3----------------------------------------------------

*Creación variable MONTH:
* Se convierte la variable "mes", originalmente en formato string, a una fecha numérica de Stata utilizando la función date().
gen fecha = date(mes, "YMD")

*Se aplica el formato de fecha diaria (%td) para una correcta visualización.
format fecha %td

* A partir de la variable de fecha generada, se extrae el número de mes mediante la función month(), obteniendo valores entre 1 y 12.
gen month = month(fecha)

*etiquetamos los valores que toma la variable para que represente el mes correspondiente
label variable month "Mes"


*dropeamos la variable fecha creada 
drop fecha


*Creación variable sucursal_change:

* La variable desvio_precio_lista se encuentra en formato string debido a la presencia de valores "NULL". Por lo tanto, se reemplazan dichos valores por missing y luego se convierte la variable a formato numérico mediante destring.

replace desvio_precio_lista = "" if desvio_precio_lista == "NULL"
destring desvio_precio_lista, replace

*Chequeamos y vemos que desvio_precio_lista paso a ser una variable numérica con 15 missings.
describe
tab desvio_precio_lista

*Ahora si genermaos la variable correspondiene:
generate sucursal_change = . 
replace sucursal_change = 1 if desvio_precio_lista > 0 & desvio_precio_lista != . 
replace sucursal_change = 0 if desvio_precio_lista <= 0 

label variable sucursal_change "Indicador de cambio de precio en la sucursal"
label define sucursal_change_lbl 0 "Sin cambio de precio" 1 "Hubo cambio de precio"
label values sucursal_change sucursal_change_lbl

*Ahora se renombra el precio promedio a precio.
rename promedio_precio_lista precio




*----------------------------------------------------Punto 4----------------------------------------------------

*Se colapsa la base a nivel comercio/bandera/mes.
*Para ello, se calcula el precio promedio mediante la media de la variable precio
*y la cantidad de sucursales que cambiaron de precio mediante la suma del indicador sucursal_change, ya que esta variable toma valor 1 si hubo cambio y 0 en caso contrario.

collapse (mean) precio (sum) sucursal_change, by(id_comercio id_bandera month)



*----------------------------------------------------Punto 5----------------------------------------------------



*Ahora, unimos la base actual con la información de comercios, guardada en el tempfile para que coincida el formato y no sea excel, usando como llave compuesta id_comercio e id_bandera

*En este caso se utiliza un merge m:1 ya que en la base actual estas combinaciones se repiten en múltiples observaciones (una por cada mes disponible), mientras que en la base de comercios cada combinación aparece una única vez. Por este motivo, no corresponde un merge 1:1, ya que la clave no es única en ambas bases, ni un merge m:m, dado que en la base de comercios las combinaciones no se repiten. Entonces:
merge m:1 id_comercio id_bandera using `comercios', generate(merge_comercios)

* Conservamos solo las observaciones con correspondencia en ambas bases
keep if merge_comercios == 3

* Eliminamos variables auxiliares creadas en este punto
drop merge_comercios

*La variable bandera identifica la marca comercial, pero al ser string no resulta conveniente para algunos procedimientos. 
*Por ello, se genera un identificador numérico llamado store a partir de dicha variable.
egen store = group(Bandera), label

label variable store "Identificador numérico de la bandera"




*----------------------------------------------------Punto 6----------------------------------------------------

*En primer lugar, se ordenan las observaciones por store y mes. Esto es necesario para asegurar que, dentro de cada store, los meses se encuentren en orden cronológico, permitiendo identificar correctamente el primer mes disponible.
sort store month


*A continuación, se genera la variable precio_base, que corresponde al precio del primer mes disponible dentro de cada store. Para ello, se utiliza la notación [1], que indica la primera observación de cada grupo una vez ordenado.
by store: gen precio_base = precio[1]


*Luego, se construye el índice de precios, tomando como base 100 el precio del primer mes disponible en cada store. El índice se calcula como el cociente entre el precio de cada mes y el precio base
gen precio_indice = (precio/precio_base)

*Se ajusta el formato de la variable precio_indice para mejorar su visualización, limitando la cantidad de decimales mostrados.
format precio_indice %9.2f



*----------------------------------------------------Punto 7----------------------------------------------------


twoway (line precio_indice month if store==1, sort lcolor(green) lwidth(medium) lpattern(solid)) (line precio_indice month if store==2, sort lcolor(green) lwidth(medium) lpattern(dash)) (line precio_indice month if store==3, sort lcolor(green) lwidth(medium) lpattern(shortdash)) (line precio_indice month if store==4, sort lcolor(orange) lwidth(medium) lpattern(solid)) (line precio_indice month if store==5, sort lcolor(blue) lwidth(medium) lpattern(solid)) (line precio_indice month if store==6, sort lcolor(blue) lwidth(medium) lpattern(dash)) (line precio_indice month if store==7, sort lcolor(blue) lwidth(medium) lpattern(shortdash)), name(gTPB1, replace) title("Evolución del precio de la Coca Cola por tienda", size(medsmall) color(black)) subtitle("Base: primer mes disponible de cada tienda", size(small) color(gs8)) xtitle("Mes", size(small)) ytitle("Índice de precio", size(small) margin(small)) xlabel(1(1)12, labsize(small) grid gstyle(dot)) ylabel(1(0.1)1.7, angle(0) labsize(small) grid gstyle(dot) format(%3.1f)) yline(1, lcolor(gs10) lpattern(dash)) legend(order(1 "Carrefour Express" 2 "Carrefour Híper" 3 "Carrefour Market" 4 "Coto" 5 "Disco" 6 "Jumbo" 7 "Vea") rows(2) size(small) symxsize(*0.6) colgap(4) region(lcolor(white))) graphregion(color(white)) plotregion(lstyle(none)) scheme(s1color)


*Se exporta el gráfico en la carpeta donde se encuentran las bases
graph export "Gráfico_1_EjercicioB.png", name(gTPB1) replace

*----------------------------------------------------Punto 8----------------------------------------------------


*Ahora se construye el índice tomando como base el mes de agosto.
*Para ello, se identifica el precio correspondiente a dicho mes mediante una condición y se asigna a todas las observaciones dentro de cada store. Luego, se calcula el índice como la relación entre el precio de cada mes y el precio de agosto.
bysort store: egen precio_base_agosto = max(cond(month==8, precio, .))
gen precio_indice_agosto = (precio/precio_base_agosto)
format precio_indice_agosto %9.2f



*----------------------------------------------------Punto 9----------------------------------------------------


twoway (line precio_indice_agosto month if store==1, sort lcolor(green) lwidth(medium) lpattern(solid)) (line precio_indice_agosto month if store==2, sort lcolor(green) lwidth(medium) lpattern(dash)) (line precio_indice_agosto month if store==3, sort lcolor(green) lwidth(medium) lpattern(shortdash)) (line precio_indice_agosto month if store==4, sort lcolor(orange) lwidth(medium) lpattern(solid)) (line precio_indice_agosto month if store==5, sort lcolor(blue) lwidth(medium) lpattern(solid)) (line precio_indice_agosto month if store==6, sort lcolor(blue) lwidth(medium) lpattern(dash)) (line precio_indice_agosto month if store==7, sort lcolor(blue) lwidth(medium) lpattern(shortdash)), name(gTPB2 , replace) title("Evolución del precio de la Coca Cola por tienda", size(medsmall) color(black)) subtitle("Base agosto 2024", size(small) color(gs8)) xtitle("Mes", size(small)) ytitle("Índice (base agosto 2024)", size(small) margin(small)) xlabel(1(1)12, labsize(small) grid gstyle(dot)) ylabel(0.6(0.1)1.3, angle(0) labsize(small) grid gstyle(dot) format(%3.1f)) yline(1, lcolor(gs10) lpattern(dash)) legend(order(1 "Carrefour Express" 2 "Carrefour Híper" 3 "Carrefour Market" 4 "Coto" 5 "Disco" 6 "Jumbo" 7 "Vea") rows(2) size(small) symxsize(*0.6) colgap(4) region(lcolor(white))) graphregion(color(white)) plotregion(lstyle(none)) scheme(s1color)


*Se exporta el gráfico en la carpeta donde se encuentran las bases

graph export "Gráfico_2_EjercicioB.png", name(gTPB2) replace

*----------------------------------------------------Punto 10----------------------------------------------------


preserve

*Con el objetivo de comparar niveles de precios entre tiendas en un período homogéneo, se restringe la base a las observaciones correspondientes desde agosto en adelante. De este modo, la comparación se realiza sobre los mismos meses para todas las tiendas. Luego, se colapsa la base calculando el precio promedio por tienda (store) para el período agosto–diciembre de 2024.
keep if month >= 8 
collapse (mean) precio, by(store)


gsort - precio
gen store_orden = _n
label define store_orden_lbl 1 "Carrefour Express" 2 "Jumbo" 3 "Carrefour Hipermercado" 4 "Vea" 5 "Carrefour Market" 6 "Disco" 7 "Coto"
label values store_orden store_orden_lbl


graph bar precio, over(store_orden, sort(1) descending label(labsize(vsmall) angle(0))) bargap(60) name(gTPB3, replace) title("Precio promedio agosto–diciembre 2024 de la Coca Cola", size(medsmall) color(navy)) subtitle("Comparación de niveles de precios entre tiendas (en pesos argentinos)", size(vsmall) color(gs8)) ytitle("") ylabel(none) yscale(noline) blabel(bar, pos(outside) format(%9.2f) size(vsmall)) bar(1, color("eltgreen")) legend(off) graphregion(color(white)) plotregion(color(white)) scheme(s1color)


*Se exporta el gráfico en la carpeta donde se encuentran las bases

graph export "Gráfico_3_EjercicioB.png", name(gTPB3) replace

restore 


*Guardamos la base final
save "TPB - Antonio Bugallo.dta", replace