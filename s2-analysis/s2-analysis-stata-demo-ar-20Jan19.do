// SSSP005
// Session Three: Data Visualisation for Analysis
// Alasdair Rutherford
// University of Stirling
// Created: 2017
// Last edited: 31 Jan 2020


// Preparation

clear
global path1 "h:\sssp005\data\" 


// In this practical we explore some visualisation methods for:

		// Distribution of individual variables
		// Exploring bivariate associations
		// Multivariate analysis - regression diagnostics
		// Multivariate analysis - regression coefficients
		
// We are using an open data set of Eurovision Song contest entries



// ===========================================================
// Univariate - understand the distribution of your variables

// Metric (ratio or interval)

* Use a histogram to examine the distribution of a metric variable

use "$path1\eurovision.dta", clear

hist points

hist points, bin(10)
hist points, bin(20)
hist points, width(10)
hist points, width(20)

* Discrete forces the graph to use unique values as bins
hist points, discrete
hist points, discrete width(10)

* Default is density (area of bars equal to 1), also fraction (sum height ==1)
* or percent (sum height == 100)

hist points, fraction
hist points, percent

* Density plots
hist points, normal  // The normla curve plotted will have the same mean and sd as the data
hist points, kdensity 

* Getting more advanced, you can label in std devs

sum points
forvalues i = 0(1)6 {
	local tick`i' = `r(mean)' + (`i' - 3) * `r(sd)'
	di "tick`i'"
}

hist points, discrete ///
	xaxis(1 2) ///
	xlabel(`tick0' "-3 SD" `tick1' "-2 SD" `tick2' "-1 SD" `tick3' "mean" `tick4' "+1 SD" `tick5' "+2 SD" `tick6' "+3 SD",axis(2))

* And again, removing the SD labels that fall below zero, and introducing some nicer formatting
hist points, xaxis(1 2) ///
	xlabel(`tick2' "-1 SD" `tick3' "mean" `tick4' "+1 SD" `tick5' "+2 SD" `tick6' "+3 SD",axis(2)) ///
	graphregion(fcolor(white))
	
	
* Verging on bivariate analysis, you can also compares histograms across categories
hist points, by(artistgender) 


* Now let's put that all together, with some nice formatting ...
* (note that the labelling for mean and SDs refers to the combined sample mean.
* We could do it separately for each case instead ... one to try at home!
sum points
forvalues i = 0(1)6 {
	local tick`i' = `r(mean)' + (`i'-3) * `r(sd)'
	di "tick`i'"
}
hist points, by(artistgender) width(5) color(dkorange) normal normopts(lcolor(dknavy)) ///
	xaxis(1 2) ///
	xlabel(`tick2' "-1 SD" `tick3' "mean" `tick4' "+1 SD" `tick5' "+2 SD" `tick6' "+3 SD",axis(2)) ///
	graphregion(fcolor(white))

	
// Categorical

* For nominal or ordinal data you can explore distribution with a frequency
* bar chart, like we looked at last time.

tab country

* We are interested in countries, so we use country as the over group
* We want to list the number of entries that they have had, so we count 'years'
* for each country.

* This graph is sorted by frequency
graph bar (count) year, over(country, label(labsize(half_tiny)) sort((count) year) descending) bar(1, color(dkorange))  bar(2, color(dknavy)) ///
	title("Eurovision: No. of Competitions Entered") subtitle("") ///
	note("Source: Eurovision Song Contest  Produced: $S_TIME  $S_DATE") 	///
	ytitle("No. Years entered") ///
	graphregion(fcolor(white))

* This graph is sorted by region
graph bar (count) year, over(country, label(labsize(half_tiny)) sort(region) descending) bar(1, color(dkorange))  bar(2, color(dknavy)) ///
	title("Eurovision: No. of Competitions Entered") subtitle("") ///
	note("Source: Eurovision Song Contest  Produced: $S_TIME  $S_DATE") 	///
	ytitle("No. Years entered") ///
	graphregion(fcolor(white))	
	


// ===========================================================
// Bivariate analysis

// For Bivariate analysis we are most interested in exploring patterns of
// association.  We will therefore make use of the graphs that we explored last time:
// Scatterplots, line graphs (metric-metric)
// Bar charts (categorical-categorical; metric-categorical)



* How has the UK done over time?

twoway (line points year if country==48)

* Oh dear - what went wrong with the graph?

sort year
twoway (line points year if country==48)

twoway (line norm year if country==48)

* Let's compare to regional averages - just focussing on countries whcih made it to the finals

keep if infinal

capture drop regav
bysort region year: egen regav = mean(norm)

twoway (line norm year if country==48) ///
		(line regav year if region==1) ///
		(line regav year if region==2) ///
		(line regav year if region==3) ///
		(line regav year if region==4) ///
		(line regav year if region==5) 

* Messy - let's tidy it up

twoway (line norm year if country==48, lwidth(thick)) ///
		(line regav year if region==1, lwidth(thin)) ///
		(line regav year if region==2, lwidth(thin)) ///
		(line regav year if region==3, lwidth(thin)) ///
		(line regav year if region==4, lwidth(thin)) ///
		(line regav year if region==5, lpattern(dash)), ///
		legend(label(1 "UK") label(2 "Former Socialist Bloc") label(3 "Former Yugoslavia") label(4 "Independent") label(5 "Scandinavia") label(6 "W. Europe")) ///
		title("Eurovision: Points by Year") subtitle("") ///
		note("Source: Eurovision Song Contest  Produced: $S_TIME  $S_DATE") 	///
		ytitle("Years") xtitle("Points") ///
		graphregion(fcolor(white))	


* Let's look again at scatter plots

* Here's a simple scatter plot
twoway (scatter points energy), ///
		graphregion(fcolor(white))		

* We can add in a linear fit line, and a quadratic fit line		
twoway  (scatter points energy) ///
		(lfit points energy) ///
		(qfit points energy), ///
		legend(label(1 "Points") label(2 "Linear Fit") label(3 "Quadratic Fit")) ///
		graphregion(fcolor(white))	
		
		
		

// ===========================================================
// Multivariate analysis - Graphing Models

// 

// Lets model the characteristics of songs that predict points earned
// We'll focus on the countries reaching the final

keep if infinal

* What does the relationship look like?
graph twoway (scatter norm energy) (qfit norm energy) (lfit norm energy)

* First a simple bivariate regression
reg norm energy

* we can compare the residuals to the fitted values - there shouldn't be a pattern
rvfplot

* If we store our fitted values in a variable then we can be mroe flexible in graphing
reg norm energy
capture drop p_norm
capture drop r_norm
predict p_norm
predict r_norm, residuals

* This scatter plot of points and energy also includes the fitted values: this
* is the regression line
twoway (line p_norm energy) (scatter norm energy)

* We can exmaine the distribution of the residuals
hist r_norm, normal

* This graph compares the fitted values to the observed values
* We would like to see our fitted values clustered around the observed values, 
* but the model is not a great fit.
twoway (scatter p_norm norm) (line norm norm)

* Let's add in another explanatory variable	
reg norm i.artistgender energy, 
rvfplot
capture drop p2_norm
predict p2_norm

* Now that we have a second explanatory variable the fitted values are no longer a simple line
* In fact there is a line for each value of artist gender.  
twoway (scatter p2_norm energy) (scatter norm energy)

* It's a bit hard to see: let's graph this explicitly.	
twoway  (scatter norm energy, msize(tiny)) ///
		(scatter p2_norm energy if artistgender==1, msize(vsmall)) ///
		(scatter p2_norm energy if artistgender==2, msize(vsmall)) ///
		(scatter p2_norm energy if artistgender==3, msize(vsmall)) ///
		(scatter p2_norm energy if artistgender==4, msize(vsmall)), ///
		legend(label(1 "Observed") label(2 "Missing Gender") label(3 "Both") label(4 "Female") label(5 "Male")) ///
		title("Regression Results: Predicted Points")  ///
		note("Produced: $S_TIME  $S_DATE Source: Eurovision Song Contest")	///
		ytitle("Normalised Points") xtitle("Energy") ///
		graphregion(fcolor(white))

* A slightly more complex model involves interacting our two explanatory variables
* Now the regression lines have their own slopes as well as intercepts
reg norm i.artistgender#c.energy
rvfplot
capture drop p2_norm
predict p2_norm

* Again, it's a bit difficult to see
twoway (scatter p2_norm energy) (scatter norm energy)

* So we can graph them as lines	
twoway  (scatter norm energy, msize(tiny)) ///
		(line p2_norm energy if artistgender==1, msize(vsmall)) ///
		(line p2_norm energy if artistgender==2, msize(vsmall)) ///
		(line p2_norm energy if artistgender==3, msize(vsmall)) ///
		(line p2_norm energy if artistgender==4, msize(vsmall)), ///
		legend(label(1 "Observed") label(2 "Missing Gender") label(3 "Both") label(4 "Female") label(5 "Male")) ///
		title("Regression Results: Predicted Points")  ///
		note("Produced: $S_TIME  $S_DATE Source: Eurovision Song Contest")	///
		ytitle("Normalised Points") xtitle("Energy") ///
		graphregion(fcolor(white))

* Let's try a slightly more sophisticated model
		
reg norm i.artistgender energy i.region i.homeawaycountry		
rvfplot
capture drop p2_norm
predict p2_norm

* Again, it's a bit difficult to see
twoway (line p2_norm energy) (scatter norm energy)

* It's getting a bit harder to represent visually, as we can't draw a graph in four dimensions!
* So we can't use lines - so let's just plot the points
twoway  (scatter norm energy, msize(tiny)) ///
		(scatter p2_norm energy if artistgender==1, msize(vsmall)) ///
		(scatter p2_norm energy if artistgender==2, msize(vsmall)) ///
		(scatter p2_norm energy if artistgender==3, msize(vsmall)) ///
		(scatter p2_norm energy if artistgender==4, msize(vsmall)), ///
		legend(label(1 "Observed") label(2 "Missing Gender") label(3 "Both") label(4 "Female") label(5 "Male")) ///
		title("Regression Results: Predicted Points")  ///
		note("Produced: $S_TIME  $S_DATE Source: Eurovision Song Contest")	///
		ytitle("Normalised Points") xtitle("Energy") ///
		graphregion(fcolor(white))
		
// When estimating a more complicated model we need to understand what the key
// variables of interest are, and then we can focus in on visualising these.
// We will discuss this further when looking at how to communciate the story of 
// your analysis.


// ===========================================================
// Visualising regression coefficients

// Once we have lots of explanatory variables, then we may just want to visualise the coefficients
// We use an "add-on" Stata command.  if it hasn't yet been installed on your PC you will need to install it

net search coefplot
net install gr0059_1.pkg, from(http://www.stata-journal.com/software/sj15-1)

* Estimate our regression
reg norm i.artistgender energy i.region i.homeawaycountry	

* And visualise the coefficients
coefplot


* This plot comes into its own when we use it to visualise multiple models together

reg norm energy
estimates store m1

reg norm energy i.artistgender
estimates store m2

reg norm energy i.artistgender tempo
estimates store m3

reg norm energy i.artistgender tempo i.region
estimates store m4

* It combines models on the same plot. We can use most of the graphing options we
* have previously learnt to improve the look of this plot.

coefplot m1 m2 m3 m4, ///
	plotlabels("Model 1" "Model 2" "Model 3" "Model 4") ///
	title("Regression Coeffients Modelling Points")  ///
	graphregion(fcolor(white))


// EXTENSION - if you have time
// We can also visualise non-linear regressions
// e.g. logistic regression of a binary dependent variable

use $path1\eurovision.dta, clear

sum loudness
gen loud = (loudness>=`r(mean)')
tab loud

logit loud energy duration acousticness danceability tempo speechiness key liveness time_sigture mode valence happiness

* Graph the sensitivity and specificty for different probability cut-offs
lsens

predict ploud, pr

twoway scatter ploud loudness
twoway scatter ploud norm

	
	
	
// =====================================================================		
// Practical Exercise	

* Have Eurovision song entries got louder over time?

* 	(1) Describe how loudness has changed over time.  Break down by a relevant sub-group.

* 	(2) Estimate a regression model of loudness, and visualise the results.

* Create a new syntax file usuing your template  You can copy & paste and edit syntax from above
* to build up your graphs.

* Remember to think about the use of text, colour, shape and labelling in
* producing your graphs.



