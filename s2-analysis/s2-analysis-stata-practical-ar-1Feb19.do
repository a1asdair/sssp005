// SSSP005
// Session Three: Data Visualisation for Analysis
// Alasdair Rutherford
// University of Stirling
// 2017


// Preparation

clear
global path1 "h:\sssp005\data\" 
global path2 "h:\sssp005\output\"

capture mkdir $path2

set more off

// In this practical we explore some visualisation methods for:

		// Distribution of individual variables
		// Exploring bivariate associations
		// Multivariate analysis - regression diagnostics
		// Multivariate analysis - regression coefficients
		
// We are using an open data set top grossing Hollywood films

// Visualise the data

use "$path1\hollywood.dta", clear


// Dependent variables: worldwidegross and profitability
// Explanatory variables: audiencescore (metric); rottentomatoes (metric); year(cat) genre(cat) leadstudio(cat)


 // Distribution of individual variables
 // Produce some graphs below describing the individual variables
 
 
 
 
 // Exploring bivariate associations
 // Graph some of the key bivariate associations in the data
 
 
 
 // Regression Modelling
 // From your visualisations above, select one variable as
 // your dependent variable to be modelled
 
 // Estimate three regression models for your dependent variable, with different
 // explanatory variable specifications
 
 
 // Visualise some model diagnostics for these three models
 
 
 //  Visualise the regression coefficients for your three models
 
 
 
 // Briefly summarise your findings below:
 
