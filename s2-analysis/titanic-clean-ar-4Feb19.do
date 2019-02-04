// SSSP005
// Session Two: Principles of Data Visualisation
// Alasdair Rutherford
// University of Stirling
// 4 Feb 2019


import delimited C:\Users\ar34\Desktop\titanic.csv

label define class 1 "First Class" 2 "Second Class" 3 "Third Class"
label values pclass class
tab pclass

label variable pclass "Passenger Class"

tab survived
label variable survived "Passenger survived"

tab sex
encode sex, gen(sexcat)
tab sexcat
tab sexcat, nol
gen female = sex=="female"
tab female


save "H:\sssp005\data\titantic-ar-4Feb19.dta"

