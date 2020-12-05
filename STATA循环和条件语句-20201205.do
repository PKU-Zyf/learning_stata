/*
STATA循环和条件语句
z.yf@pku.edu.cn
最后更新：2020-12-05
致谢：aarontaix@gmail.com
*/

* 1. foreach循环语句：foreach … in …
sysuse auto, clear

foreach var in price trunk length {
    summarize `var'
}

* 1. foreach循环语句：foreach … of varlist …
sysuse auto, clear

foreach var of varlist price-length displacement {
    summarize `var'
}

sysuse auto, clear

global my_vars price-headroom length displacement
foreach var of varlist $my_vars {
    summarize `var'
}
foreach var of varlist $my_vars {
    egen mean_`var' = mean(`var')
    dis mean_`var'
}

sysuse auto, clear

foreach var of varlist * {
    summarize `var'
}

* 1. foreach循环语句：foreach … of numlist …
sysuse auto, clear

levelsof price, local(price_levels)
foreach num of numlist `price_levels'{
    dis `num'
}
// 排序并遍历指定变量在每个样本的观测值：levelsof

* 2. forvalues循环语句：步长为1
forvalues i = 1/10 {
    dis `i'
}

* 2. forvalues循环语句：指定步长
forvalues i = 0 (2) 10 {
    dis `i'
}
forvalues i = 1 (2) 10 {
    dis `i'
}
forvalues i = 0 (-2) -10 {
    dis `i'
}

* 2. forvalues循环语句：指定前两项
forvalues i = 1 3 to 9 {
    dis `i'
}
forvalues i = 1 -1 to -10 {
    dis `i'
}
forvalues i = 1 -1 : -10 {
    dis `i'
}

* 3. while循环语句
local j = 0
while `j' <= 10 {
    dis `j'
    local j = `j' + 1
}

* 4. 条件语句：if
sysuse auto, clear

egen mean_weight = mean(weight)
gen is_heavy = 0
replace is_heavy = 1 if weight >= mean_weight

* 4. 条件语句：if … (else) …
forvalues k=1/10 {
    if `k' / 2 == int(`k' / 2) {
        dis "`k' is an even number."
    }
    else {
        dis "`k' is an odd number."
    }
}

* 4. 条件语句：if … else if … (else) … 
forvalues k=1 (0.5) 10 {
    if `k' != int(`k') {
        dis "`k' is a decimal."
    }
    else if `k' / 2 == int(`k' / 2) {
        dis "`k' is an even number."
    }
    else {
        dis "`k' is an odd number."
    }
}

* 5. 循环的中断：continue
sysuse auto, clear

foreach var of varlist mpg-gear_ratio {
    egen sd_`var' = sd(`var')
    egen mean_`var' = mean(`var')
    gen cv_`var' = sd_`var' / mean_`var'
    if cv_`var' < cv_mpg {
        continue
    }
    dis "`var' " cv_`var'
}

* 5. 循环的中断：continue, break
sysuse auto, clear

foreach var of varlist mpg-gear_ratio {
    egen sd_`var' = sd(`var')
    egen mean_`var' = mean(`var')
    gen cv_`var' = sd_`var' / mean_`var'
    if cv_`var' < cv_mpg {
        continue, break
    }
    dis "`var' " cv_`var'
}

