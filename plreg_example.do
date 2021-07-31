/*******************************************************************/
program drop _all
/*******************************************************************/
use plreg_example, clear

summarize tc    , meanonly
	local mean_tc     = r(mean)
summarize cust  , meanonly
	local mean_cust   = r(mean)
summarize custsq, meanonly
	local mean_custsq = r(mean)

reg   tc cust custsq wage pcap puc kwh life lf kmwire
// note normalization
generate quad_func = `mean_tc'+_b[cust]*(cust-`mean_cust')+_b[custsq]*(custsq-`mean_custsq')

plreg tc wage pcap puc kwh life lf kmwire, nlf(cust) gen(func) bw(1) ord(1) l(95) nodraw

matrix COEFF = e(b)
matrix score xb_diff = COEFF
summarize xb_diff, meanonly
local mean_xb_diff=r(mean)
generate tc_hat = tc-(xb_diff-`mean_xb_diff') // note normalization

twoway scatter tc_hat cust, msize(medium) mcolor(gs4) msymbol(Oh) || 						///
	   line func quad_func cust, lwidth(medthick medthick) lpattern(solid shortdash)    	///
       ytitle(log total cost per year, size(3))                                             ///
       ylabel(5(0.2)6, angle(horizontal) gmax labsize(3))                                   ///
       xtitle(log customers, size(2.9) margin(0 0 0 2)) xlabel(, labsize(3))                ///
       legend(pos(2) ring(0) col(1) size(2.5) symxsize(8)                                   ///
	   		  textwidth(26) region(style(outline)) margin(zero) bmargin(large)              ///
			  order(2 3) label(2 "Non-parametric function") label(3 "Quadratic function"))  ///
       plotregion(style(none)) graphregion(fcolor(gs16) margin(small) lstyle(none))

