clear all
set more off


*Parte 1 del TPA: 

*1: Abrimos la base de datos usando sysuse al estar utilizando una base propia del stata, por lo que no es necesario definir carpeta que mirar para abrir la base.
sysuse "lifeexp.dta", clear



*2: Exploramos un poco la base mirando cantidad de observaciones, variables y que tipo de variables tenemos con el comando describe
describe 

*Se observa que la base de datos contiene 68 observaciones y 6 variables de distinto tipo. De estas, una es de tipo texto (country), otra es categórica (region), mientras que las restantes son numéricas. Entre las variables numéricas, dos son de tipo byte (lexp y safewater), y dos son de tipo float (popgrowth y gnppc), es decir, variables con capacidad para almacenar valores con hasta 7 decimales. 

*3: Para tener un resumen estadístico de todas las variables numéricas podemos usar el comando summarize. Así obtenemos la cantidad de observaciones de todas las variables elegidas, su media, el desvió estándar, el min y el max.

*En este caso, al solo solicitar de las numéricas:
summarize lexp gnppc popgrowth safewater 

*No se incluye la variable country por ser de tipo texto, ni la variable region al ser categórica. 

*Parte 2 del TPA: 
*4: Renombrar lexp a life_exp, gnppc a gnp_pc, popgrowth a pop_growth y safewater a safe_water. Para ello:
rename (lexp gnppc popgrowth safewater) (life_exp gnp_pc pop_growth safe_water)


*5: re etiquetar las variables. Para ello:
label variable country "País"
label variable pop_growth "Tasa de crecimiento anual promedio"
label variable life_exp "Esperanza de vida"
label variable gnp_pc "Ingreso per capita (USD)"
label variable safe_water "Población con acceso a agua segura (%)"
label variable region "Región"

*6: Crear una variable categórica de ingreso bajo, medio-bajo, medio-alto y alto. Usando como referencia los cortes: 1100, 4500 y 14000 dólares per capita. Asignarle etiqueta de variable "Categoria de ingreso" y etiquetas de valores.
generate ingreso_cat=. 
replace ingreso_cat=1 if gnp_pc <= 1100
replace ingreso_cat=2 if gnp_pc > 1100  & gnp_pc <= 4500
replace ingreso_cat=3 if gnp_pc > 4500  & gnp_pc <= 14000
replace ingreso_cat=4 if gnp_pc > 14000 & gnp_pc != . 

label variable ingreso_cat "Categoria de ingreso"

label define ingreso_cat_lbl 1 "Bajo" 2 "Medio-bajo" 3 "Medio-alto" 4 "Alto"
label values ingreso_cat ingreso_cat_lbl

*7: Crear una dummy cobertura_alta que valga 1 si safe_water es al menos 80 y 0 si es menor a 80. Asignarle etiqueta de variable "Cobertura de agua segura" y etiquetas de valores "Baja" y "Alta".
*Para ello primero confirmamoes que la variable safe_water si tiene varios missing (en summarize se ve que de las 68 obs totales, tiene 40 asignadas). Por lo tanto, para generar la variable nueva pedida:
generate cobertura_alta = .
replace cobertura_alta=1 if safe_water >= 80 & safe_water != . 
replace cobertura_alta=0 if safe_water < 80


label variable cobertura_alta "Cobertura de agua segura"

label define cobertura_alta_lbl 1 "Alta" 0 "Baja"
label values cobertura_alta cobertura_alta_lbl



*Parte 3 del TPA: 

*8: Eliminar las observaciones sin dato en safe_water y la correspondiente a "Yugoslavia".
* como vimos, safe_water tiene 28 missing, por lo que eliminamos esas observaciones
drop if safe_water ==.

*Al hacer eso, se eliminó la correspondiente a "Yugoslavia", al no tener dato en safe_water

drop if country == "Yugoslavia"

*notar que al hacer esto dice que se han eliminado 0 observaciones, al ya haber sido eliminada

*9: Mostrar los 10 países con mayor esperanza de vida. Para ello, se ordenan las observaciones en forma descendente según life_exp mediante gsort. Además, se listan los países cuyo valor de esperanza de vida es mayor o igual a 75 para que todos los que compartan 75 (el valor del ultimo puesto), aparezcan en la lista
gsort - life_exp
list region country life_exp in 1/10, clean
list region country life_exp if life_exp >= 75, clean

*Parte 4 del TPA: 
*10:Obtener media, mediana, desvío estándar, mínimo y máximo de life_exp, safe_water e ingreso_miles. Para ello primero creamos la variable de ingresos per cápita en miles: 
gen ingreso_miles = gnp_pc / 1000
label variable ingreso_miles "Ingreso per capita (miles USD)"

tabstat life_exp safe_water ingreso_miles, statistics(mean p50 sd min max)


*11: Crear una tabla que muestre los ingresos per cápita promedios según region.
table region, stat(mean gnp_pc) nformat(%9.2fc mean)

*12: Obtener la media de esperanza_vida segun categoria de ingreso. Intentar replicar la tabla con el formato de la consigna:
table ingreso_cat, stat(mean life_exp) stat(sd life_exp) stat(count life_exp) nformat(%9.1f mean) nformat(%9.1f sd)

*13: Crear una tabla que muestre, segun la categoria de agua segura, el promedio, el desvio estandar y el maximo de esperanza_vida. Intentar replicar la tabla con el formato de la consigna: 
table () (cobertura_alta), stat(mean life_exp) stat(sd life_exp) stat(max life_exp) nformat(%9.1f mean) nformat(%9.1f sd)

*14: Crear una tabla que muestre, entre los países con gnp_pc menor a 4000, la cantidad y el porcentaje por fila de países con cobertura baja y alta de agua segura según región.

tabulate region cobertura_alta if gnp_pc < 4000, row


*Parte 5 del TPA: 

*15: Replicar un gráfico de dispersión (scatter) de life_exp contra safe_water respetando un estilo prolijo. De esta forma: 
twoway (scatter life_exp safe_water, msymbol(oh) mcolor(teal) msize(medium)) (scatter life_exp safe_water if country=="Argentina", msymbol(o) mcolor(eltblue) msize(large) mlabel(country) mlabpos(3) mlabcolor(navy)), legend(off) name(gTPA, replace) title("Esperanza de vida y acceso a agua segura", color(navy) size(medium)) xtitle("Acceso a agua segura (%)", size(small)) ytitle("Esperanza de vida", size(small)) ylabel(, format(%9.0fc) grid glpattern(dot) glcolor(gs12) labsize(small)) xlabel(, format(%9.0fc) grid glpattern(dot) glcolor(gs12) labsize(small)) scheme(s1color) plotregion(lstyle(none))
 
graph export "scatter_ejercicioA.png", name(gTPA) replace

