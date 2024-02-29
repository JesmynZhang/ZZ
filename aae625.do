clear
use "C:\Users\zhijie\Downloads\schoolexp.dta"

*section 1: Simple Regression Models
	*Run a regression of "math4" on "exppp
regress math4 expp
	*Interpret the regression
summarize math4 exppp 
	*invoke the CIA
regress math4 exppp lunch 
	*Run the specification that includes "lunch" as an additional control variable
estimates store my_model
	* Calculate the omitted variable bias
		*estimate beta_YXo by regressing "math4" on "lunch":
		regress math4 lunch
		estimates store reg1
		*estimate beta_XoX by regressing "exppp" on "lunch":
		regress exppp lunch
		estimates store reg2
		*retrieve and multiply the coefficients
		scalar beta_YXo = _b[lunch]  // from the first regression of math4 on lunch
		scalar beta_XoX = _b[lunch]  // from the second regression of exppp on lunch
		scalar OVB = beta_YXo * beta_XoX
		display "The estimated omitted variable bias (OVB) is: ", OVB
		
*section 2: Frisch-Waugh-Lovell Theorem
	* Use the decomposition suggested by FWL to calculate the coefficient on "exppp" in the multi-variate regression.
	regress exppp lunch
	predict exppp_resid, resid //Regress the Independent Variable of Interest ("exppp") on the Control Variables
	regress math4 lunch
	predict math4_resid, resid //Regress the Dependent Variable ("math4") on the Control Variables
	regress math4_resid exppp_resid //Regress the Residuals of the Dependent Variable on the Residuals of the Independent Variable
	
	* Use the decomposition suggested by FWL to calculate the coefficient on "exppp" in the multi-variate regression.
	estimates store fwl_model
	estimates table my_model fwl_model, b se //Compare Coefficients
	
	*Create two scatter plots
	scatter math4 exppp, title("Bivariate Regression of math4 on exppp") name(bivariate, replace)
	graph save "C:\Users\zhijie\Downloads\bivariate_plot.gph", replace  //Scatter Plot for Bivariate Regression
	scatter math4_resid exppp_resid, title("Scatter Plot for FWL Transformed Data") name(fwl, replace)
	graph save "C:\Users\zhijie\Downloads\fwl_plot.gph", replace //Scatter Plot for Transformed Data Using FWL Method

	*Combine the two scatter plots
	graph combine  "C:\Users\zhijie\Downloads\bivariate_plot.gph" "C:\Users\zhijie\Downloads\fwl_plot.gph", title("Combined Scatter Plots")
	graph export "C:\Users\zhijie\Downloads\combined_scatter_plots.png", replace






	