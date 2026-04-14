*** MAECO UNLP ***
** Instrumentos Computacionales
* Opcional A
* Vicente Liut
* 14/4/2026


* Seteo general del workspace
clear all
set more off


**# Parte #1

* Cargo la base de datos, incluida en Stata
sysuse lifeexp , clear 

d
* La base tiene 6 variables y 68 observaciones
sum
* Country es string
* gnppc tiene 5 missing, safewater 28 


sum popgrowth lexp gnppc safewater

**# Parte #2

rename lexp		life_exp
rename gnppc	gnp_pc
rename popgrowth	pop_growth
rename safewater	safe_water 

label variable	country    "País"
label variable	pop_growth "Tasa de crecimiento anual promedio"
label variable	life_exp   "Esperanza de vida"
label variable	gnp_pc     "Ingreso per capita (USD)"
label variable	safe_water "Población con acceso a agua segura (%)"
label variable	region     "Región"


gen cat_ingreso = .
replace cat_ingreso = 1 if gnp_pc <= 1100
replace cat_ingreso = 2 if gnp_pc >  1100	&	gnp_pc <= 4500
replace cat_ingreso = 3 if gnp_pc >  4500	&	gnp_pc <= 14000
replace cat_ingreso = 4 if gnp_pc >  14000	&	gnp_pc != .

label variable cat_ingreso "Categoria de ingreso"

label define cat_lbl	///
	1	"Bajo" ///
	2	"Medio-bajo" ///
	3	"Medio-alto" ///
	4	"Alto"
label values cat_ingreso cat_lbl


**# Parte #3

drop if safe_water == .

drop if country	== "Yugoslavia, FR (Serb./Mont.)"
* la unica obs de Yugoslavia se dropeo al no tener dato de "safe_water"

* Ordena la base de datos de mayor a menor precio
gsort - life_exp
list region country life_exp in 1/10, clean
list region country life_exp if life_exp >= 75, clean



**# Parte #4

gen ingreso_miles = gnp_pc / 1000
label variable ingreso_miles "Ingreso per capita (miles USD)"


tabstat life_exp safe_water ingreso_miles	, s(mean median sd min max) c(s)


table (region) , stat(mean ingreso_miles) nformat(%9.2fc mean)

table (cat_ingreso) , stat(mean life_exp) nformat(%9.1fc mean) stat(sd life_exp) nformat(%9.1fc sd) stat(count life_exp) nformat(%9.0fc count)


gen cat_sw = .
replace cat_sw = 0 if safe_water < 80
replace cat_sw = 1 if safe_water >= 80 & safe_water != .

label variable cat_sw "Cobertura de agua segura"
label define cat_sw_lbl	///
	0	"Bajo" ///
	1	"Alto"
label values cat_sw cat_sw_lbl

table () (cat_sw) , stat(mean life_exp) nformat(%9.1fc mean) stat(sd life_exp) nformat(%9.1fc sd) stat(max life_exp) nformat(%9.0fc max)


tab cat_sw region if gnp_pc < 4000, row


**# Parte #5

twoway ///
	(scatter life_exp safe_water, msymbol(circle_hollow) mcolor(teal) msize(small) mlw(medium)) ///
	(scatter life_exp safe_water if country=="Argentina", ///
		mcolor(eltblue) msize(large) mlabel(country) mlabpos(3) mlabcolor(navy) ) ///
	, legend(off) ///
	scheme(s1color) ///
	graphregion(color(white)) ///
	plotregion(color(white) lcolor(black) lwidth(medium) ) ///
	title("Esperanza de vida y acceso a agua segura", color(dknavy)) ///
	ylabel(, format(%9.0fc) labsize(small) grid gstyle(dot) glc(grey)) ///
	xlabel(, format(%9.0fc) labsize(small) grid gstyle(dot) glc(grey)) 
