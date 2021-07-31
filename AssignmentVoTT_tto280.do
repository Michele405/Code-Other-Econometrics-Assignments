//////////Assignment 5////////////
///// Author:
///
///     ('-.         .-') _             (`-.                
///    ( OO ).-.    ( OO ) )          _(OO  )_              
///    / . --. /,--./ ,--,'       ,--(_/   ,. \ .-'),-----. 
//    | \-.  \ |   \ |  |\       \   \   /(__/( OO'  .-.  '
/// .-'-'  |  ||    \|  | )       \   \ /   / /   |  | |  |
///  \| |_.'  ||  .     |/         \   '   /, \_) |  |\|  |
///   |  .-.  ||  |\    |           \     /__)  \ |  | |  |
///   |  | |  ||  | \   |            \   /       `'  '-'  '
///   `--' `--'`--'  `--'             `-'          `-----' 


clear
log using assignment5.log, replace // store result in log file
log close
set more off





///Assignment I: Exploratory analysis///

///2.1.2
insheet using "D:\Dropbox\Econometrics\W5\VOTTdata.csv" // imput excel file in stata
describe
// derive summary statistics (minimum, average, maximum) of the reference travel time, income for the whole sample
 sum basetime income
 
// summary statistics (minimum, average, maximum) for males and females separately.
sum basetime income if gender==1 // for male
sum basetime income if gender==2 // for female
// Probability of fastest alternative is chosen
display ( 1/(1+exp(3.75-0.833333)))
// Probability of slowest alternative is chosen
display ( 1/(1+exp(3.75-0.833333)))

//
gen new = cost1 - cost2
gen new1 = time2- time1

gen a = new*new1 if new>0 & new1 <0

// Assignment II
// Transform data
recode y (1=1) (2=0), gen(y1) // recode y as a binary with 1: choose 1
// and 0 choose 2
gen difftime = time1 - time2 // difference between time1 and time2

gen diffcost = cost1 - cost2 // difference between cost1 and cost2

logit y1 diffcost difftime
ereturn list // return stored values
matrix list e(b) // list coefficients
matrix ebb = e(b) // create a matrix of coefficients
display ebb[1,2]/ebb[1,1] // VOTT = beta time/ beta cost



/// excluding income > 4
drop if income >4
logit y1 diffcost difftime
matrix ebb = e(b) // create a matrix of coefficients
display ebb[1,2]/ebb[1,1] // VOTT = Beta time/beta cost

clear
// Assignment III 
insheet using "D:\Dropbox\Econometrics\W5\VOTTdata.csv"
// Transform data
recode y (1=1) (2=0), gen(y1) // recode y as a binary with 1: choose 1
// and 0 choose 2
gen difftime = time1 - time2 // difference between time1 and time2

gen diffcost = cost1 - cost2 // difference between cost1 and cost2

logit y1 diffcost c.diffcost#income difftime // model with interation effect of the variable INC
margins, eyex(diffcost) at(income=(1(1)8))
marginsplot // plot elasticity

logit y1 diffcost c.diffcost#income c.difftime#gender difftime
clear
 
 // Assignment IV
insheet using "D:\Dropbox\Econometrics\W5\VOTTdata.csv" 
xtset id // indicate panel data in Sata
recode y (1=1) (2=0), gen(y1) // recode y as a binary with 1: choose 1
// and 0 choose 2
gen difftime = time1 - time2 // difference between time1 and time2

gen diffcost = cost1 - cost2 // difference between cost1 and cost2
//estimate a panel logit model with FE
 xtlogit y1 difftime diffcost, fe
//estimate a panel logit model with RE
 xtlogit y1 difftime diffcost, re

break

