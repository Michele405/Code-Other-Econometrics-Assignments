
use "C:\Users\claud\Desktop\Econometrics\stata\data\ts.dta"

* set time format
generate time=q(1957q1)+_n-1
format time %tq
sort time
tsset time
  
* generate 12 regressions AR(1), AR(2), AR(12), and compute the BIC for each
forvalues i=1/12 {
	regress gdp L(1/`i').gdp if tin(1960q1,2005q1), robust
	gen BIC_`i'=ln(e(rss)/e(N))+e(rank)*(ln(e(N))/e(N)) if tin(1960q1,2005q1)
}
* summarise BIC values in the console
sum BIC*

* remove BICs from my dataset
forvalues i=1/12 {
	drop BIC_`i'
}

*alternative command to calculate this... but I get SBIC and not BIC
*varsoc gdp, maxlag(12)

*get the autocorrelation coefficients
*corrgram gdp if tin(1957q1,2005q1), noplot lags(3)

* fuller test for unit root
dfuller gdp if tin(1960q1,2005q1), lags(3)

* use data between 1960 and 1989 and predict data from 1990 to 2005, with a AR(3) model
regress gdp L(1/3).gdp if tin(1960q1,1989q4)
predict gdp_predict if tin(1990q1,2005q1)

*** alternative way instead of using predict
*estimates store gdp_model 
*forecast create expostforecast, replace 
*forecast estimates gdp_model
*forecast solve, prefix(f_gdp3) begin(tq(1990q1)) end(tq(2005q1)) static

label variable gdp "GDP growth Actual"
label variable gdp_predict "GDP Predicted"
tsline gdp gdp_predict if tin(1990q1, 2005q1)
graph export "C:\Users\claud\Desktop\Econometrics\stata\data\gdp_growth.png"

gen MSFE = (gdp_predict-gdp)^2
sum MSFE
* take square root of the mean with calculator to answer assignment question



