// SSSP005
// Session Two: Principles of Data Visualisation
// Alasdair Rutherford
// University of Stirling
// Created: 2017
// Last Updated: 31 Jan 2020

// Preparation

clear
global path1 "h:\sssp005\data\" /* data files including ghs95.dta */


* This exercise will show you how to use Stata to create scatter plots, 
* line graphs and bar graphs.  This will use the -twoway- and -graph- commands.

// =====================================================================
// Producing a scatter plot

* Scatter plots are an easy way to visualise two metric variables.  They
* are great for showing relationships between two (or more) variables, as well
* as communicating distribution.

* The core command is -twoway scatter- followed by a list of variables.  
* The first variable(s) are the Y variables, and the last variable specified
* is the X variable.

use $path1\titanic.dta, clear


* This is the simplest scatter plot
twoway scatter age fare

twoway scatter age fare, by(sex)

twoway (scatter age fare if sex=="female") (scatter age fare if sex=="male")


* Label the series
twoway (scatter age fare if sex=="female") (scatter age fare if sex=="male"), ///
	legend(label(1 "Female") label(2 "Male"))
	
* Add titles to the graph
twoway (scatter age fare if sex=="female") (scatter age fare if sex=="male"), ///
	legend(label(1 "Female") label(2 "Male")) ///
	title("Titanic Passengers: Age versus Fare") subtitle("A scatter plot of age and fare paid for men and women") ///
	note("Produced: $S_TIME  $S_DATE") caption("This is historical data derived from the passenger records.")

* Add titles to the axes
twoway (scatter age fare if sex=="female") (scatter age fare if sex=="male"), ///
	legend(label(1 "Female") label(2 "Male")) ///
	title("Titanic Passengers: Age versus Fare") subtitle("A scatter plot of age and fare paid for men and women") ///
	note("Produced: $S_TIME  $S_DATE") caption("This is historical data derived from the passenger records.")	///
	ytitle("Passenger age (years)") xtitle("Passenger Fare Paid (£)")
	
* Change the background colour
twoway (scatter age fare if sex=="female") (scatter age fare if sex=="male"), ///
	legend(label(1 "Female") label(2 "Male")) ///
	title("Titanic Passengers: Age versus Fare") subtitle("A scatter plot of age and fare paid for men and women") ///
	note("Produced: $S_TIME  $S_DATE") caption("This is historical data derived from the passenger records.")	///
	ytitle("Passenger age (years)") xtitle("Passenger Fare Paid (£)") ///
	graphregion(fcolor(white))



* Change the markers: size
twoway (scatter age fare if sex=="female", msize(small)) (scatter age fare if sex=="male", msize(small)), ///
	legend(label(1 "Female") label(2 "Male"))
	
twoway (scatter age fare if sex=="female", msize(tiny)) (scatter age fare if sex=="male", msize(tiny)), ///
	legend(label(1 "Female") label(2 "Male"))

* Change the markers: colour
twoway (scatter age fare if sex=="female", msize(small) mcolor(cranberry)) (scatter age fare if sex=="male", msize(small) mcolor(green)), ///
	legend(label(1 "Female") label(2 "Male"))
	
twoway (scatter age fare if sex=="female", msize(tiny) mcolor(gs4)) (scatter age fare if sex=="male", msize(tiny) mcolor(gs11)), ///
	legend(label(1 "Female") label(2 "Male"))	
	
* Change the markers: shape
twoway (scatter age fare if sex=="female", msize(small) msymbol(diamond)) (scatter age fare if sex=="male", msize(small) msymbol(square)), ///
	legend(label(1 "Female") label(2 "Male"))
	
twoway (scatter age fare if sex=="female", msize(small) msymbol(circle_hollow)) (scatter age fare if sex=="male", msize(small) msymbol(plus)), ///
	legend(label(1 "Female") label(2 "Male"))
	
* Use this to code by a third variable
twoway 	(scatter age fare if sex=="female" & survived==1, msize(small) mcolor(cranberry) msymbol(circle)) ///
		(scatter age fare if sex=="female" & survived==0, msize(small) mcolor(cranberry) msymbol(X)) ///
	    (scatter age fare if sex=="male"& survived==1, msize(small) mcolor(dknavy) msymbol(circle)) ///
		(scatter age fare if sex=="male"& survived==0, msize(small) mcolor(dknavy) msymbol(X) ), ///
		legend(label(1 "Female") label(2 "Female(D)") label(3 "Male") label(4 "Male(D)"))

* Or even a fourth variable
twoway (scatter age fare if sex=="female" & survived==1, msize(small) mcolor(cranberry) msymbol(circle)) (scatter age fare if sex=="female" & survived==0, msize(small) mcolor(cranberry) msymbol(X)) ///
	   (scatter age fare if sex=="male"& survived==1, msize(small) mcolor(dknavy) msymbol(circle)) (scatter age fare if sex=="male"& survived==0, msize(small) mcolor(dknavy) msymbol(X) ), ///
	legend(label(1 "Female") label(2 "Female(D)") label(3 "Male") label(4 "Male(D)")) by(pclass)

	
	
* Lets put some of this together ...
twoway (scatter age fare if sex=="female" & survived==1, msize(small) mcolor(cranberry) msymbol(circle)) (scatter age fare if sex=="female" & survived==0, msize(small) mcolor(cranberry) msymbol(X)) ///
	   (scatter age fare if sex=="male"& survived==1, msize(small) mcolor(dknavy) msymbol(circle)) (scatter age fare if sex=="male"& survived==0, msize(small) mcolor(dknavy) msymbol(X) ), ///
	legend(label(1 "Female") label(2 "Female(D)") label(3 "Male") label(4 "Male(D)")) ///
	title("Titanic Passengers: Age versus Fare") subtitle("A scatter plot of age and fare paid for men and women") ///
	note("Produced: $S_TIME  $S_DATE") caption("This is historical data derived from the passenger records.")	///
	ytitle("Passenger age (years)") xtitle("Passenger Fare Paid (£)") ///
	graphregion(fcolor(white))


// =====================================================================	
// Producing a Line Graph

* Line graphs are particularly useful for showing how a y-variable changes as we 
* move up the values of an x-variable.  Often that will be time, but in this example
* we use age.

* Many of the general formatting options are the same, so we build up this graph
* a bit quicker.

use $path1\titanic.dta, clear

* Create a variable containg the average fare by year of age
capture drop avfare
bysort age: egen avfare=mean(fare)
twoway line  avfare age

* That graph is a bit noisy, as some of teh ages don't have that many people.
* Let's smooth a bit by calculating the average fares within five-year age bands.
capture drop avfare
capture drop age5
gen age5 = round(age,5)
bysort age5: egen avfare=mean(fare)
twoway line  avfare age5

* Now let's do the same thing separately for men and women.
capture drop avfare
capture drop age5
gen age5 = round(age,5)
bysort age5 sex: egen avfare=mean(fare)
twoway (line avfare age5 if sex=="female") (line avfare age5 if sex=="male"), ///
	legend(label(1 "Female") label(2 "Male"))
	
* Change the line colour
twoway (line avfare age5 if sex=="female", lcolor(dkorange)) (line avfare age5 if sex=="male", lcolor(dknavy)), ///
	legend(label(1 "Female") label(2 "Male"))


* Change the line width
twoway (line avfare age5 if sex=="female", lcolor(dkorange) lpattern(dash)) (line avfare age5 if sex=="male", lcolor(dknavy) lpattern(dot)), ///
	legend(label(1 "Female") label(2 "Male"))


* Change the line pattern
twoway (line avfare age5 if sex=="female", lcolor(dkorange) lpattern(dash) lwidth(thin)) (line avfare age5 if sex=="male", lcolor(dknavy) lpattern(dot) lwidth(thick)), ///
	legend(label(1 "Female") label(2 "Male"))
	
	
* The general -twoway- options still apply
twoway (line avfare age5 if sex=="female", lcolor(dkorange) lpattern(dash) lwidth(thin)) (line avfare age5 if sex=="male", lcolor(dknavy) lpattern(dot) lwidth(thick)), ///
	legend(label(1 "Female") label(2 "Male")) ///
	title("Titanic Passengers: Age versus Fare") subtitle("A line graph of average fares by age for men and women") ///
	note("Produced: $S_TIME  $S_DATE") caption("This is historical data derived from the passenger records.")	///
	ytitle("Passenger Fare Paid (£)") xtitle("Passenger age (years)") ///
	graphregion(fcolor(white))

	
// =====================================================================	
// Producing Bar Graphs

* Bar garphs allow us to summarise a metric variable across a categorical variable.
* ALternatvelky we can reprot poercentages of a second categorical variable.

* Bar graphs use a slightly different syntax: -graph bar-

use $path1\titanic.dta, clear

* Here's the most basic bar graph - it just shows the average of fare
graph bar (mean) fare

* You can add in categories of an x-variable, to make it more interesting.
* pclass is the class of the ticket purchased: 1st, 2nd or 3rd.
graph bar (mean) fare, over(pclass)

* And additional groups - there are a number of ways to do this, with slightly different looks
graph bar (mean) fare, over(sex) over(pclass) 
graph bar (mean) fare,  by(sex) over(pclass)

* the option -asyvars- treats the first 'over' group as though it was split into
* separate y-var series in the command.  See the difference this makes.
graph bar (mean) fare,  over(sex) over(pclass) asyvars
graph bar (mean) fare,  by(sex)  over(pclass) asyvars


* Or alternatively a third manual way, that allows for a bit more control over
* the look of the bar graph
gen mfare = fare if sex=="male"
gen ffare = fare if sex=="female"
graph bar (mean) ffare mfare , over(pclass)

* Change the colour of the bars
graph bar (mean) ffare mfare , over(pclass) bar(1, color(dkorange))  bar(2, color(dknavy))

* Change the X-variable labels
* The labels in the bar graph come from the value labels in the X-variable, so
* if we define them then they will appear in the graph
label define passclass 1 "First Class" 2 "Second Class" 3 "Third Class"
label values pclass passclass
graph bar (mean) ffare mfare , over(pclass) bar(1, color(dkorange))  bar(2, color(dknavy))

* And label the series just like we did before
graph bar (mean) ffare mfare , over(pclass) bar(1, color(dkorange))  bar(2, color(dknavy)) ///
	legend(label(1 "Female") label(2 "Male"))

* Let's tidy it up a bit
graph bar (mean) ffare mfare , over(pclass)  bar(1, color(dkorange))  bar(2, color(dknavy)) ///
	legend(label(1 "Female") label(2 "Male")) ///
	title("Titanic Passengers: Fare paid by Passenger Class") subtitle("A bar graph of average fares by passenger class") ///
	note("Produced: $S_TIME  $S_DATE") caption("This is historical data derived from the passenger records.")	///
	b1title("Age (Years)")	///	
	ytitle("Average Passenger Fare Paid (£)") ///
	graphregion(fcolor(white))


* Let's look at another graph example, showing percentages instead of averages
* Remember that the mean of a binary variable is the proportion of '1's.

* This is just the proportion of passengers who survived
graph bar (mean) survived

* And now survival proportions for men and women separately
graph bar (mean) survived, over(sex)

* Next we can use our five-year age bands
capture drop age5
gen age5 = round(age,5)
graph bar (mean) survived, over(age5) over(sex)

* The x-axis labelling looks horrible, so we can resize the text to make it a
* bit cleare
graph bar (mean) survived, over(age5,label(labsize(vsmall))) over(sex) 

* or alternatively, for more flexibility
capture drop msurv
capture drop fsurv
gen msurv = survived if sex=="male"
gen fsurv = survived if sex=="female"
graph bar (mean) fsurv msurv, over(age5,label(labsize(vsmall)))

* And tidy it up as before ...
graph bar (mean) fsurv msurv, over(age5,label(labsize(vsmall))) bar(1, color(dkorange))  bar(2, color(dknavy)) ///
	legend(label(1 "Female") label(2 "Male")) ///
	title("Titanic Passengers: Survival Rate by Gender and Age") subtitle("A bar graph of survival") ///
	note("Produced: $S_TIME  $S_DATE") caption("This is historical data derived from the passenger records.")	///
	b1title("Age (Years)")	///
	ytitle("Proportion surviving") ///
	graphregion(fcolor(white))

	
	
	
// =====================================================================		
// Practical Exercise	

* Explore the relationship between passenger class and survival

* 	(1) Create a bar graph of survival rates by passenger class

* 	(2) Create a scatter plot of age versus fare, using colour to represent
*		survival and shape to represent passenger class

* Create a new syntax file using your template.  You can copy & paste and edit syntax from above
* to build up your graphs. Upload your syntax file to GitHub when  you have finished.

* Remember to think about the use of text, colour, shape and labelling in
* producing your graphs.



