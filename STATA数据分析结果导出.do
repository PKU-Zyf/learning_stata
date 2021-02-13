/*
STATA数据分析结果导出
z.yf@pku.edu.cn
最后更新：2020-12-13
*/


* 1. tabout

sysuse bpwide, clear // 这是一个系统自带的模拟血压数据库
global PATH = "D:/PKU-Zyf/R&STATA/tabs" // 这里输入自己的工作路径

** 一维描述统计表（频数）

tabout agegrp using "$PATH/表1_年龄段分布.xlsx", ///
replace style(xlsx) font(bold) oneway c(freq col cum) ///
f(0c 1) clab(数量 比例_% 累计比例_%) npos(col) ///
title(表1：年龄段分布)

tabout agegrp sex using "$PATH/表2_年龄段与性别分布.xlsx", ///
replace style(xlsx) font(bold) oneway c(freq col cum) ///
f(0c 1) clab(数量 比例_% 累计比例_%) npos(col) ///
title(表2：年龄段与性别分布)

** 一维描述统计表（摘要）

sysuse nlsw88, clear // 这是一个系统自带的追踪调查数据库
global PATH = "D:/PKU-Zyf/R&STATA/tabs" // 这里输入自己的工作路径

tabout occupation race using "$PATH/表3_职业、种族与薪资、工时交叉表.xlsx", ///
replace style(xlsx) font(bold) ///
c(mean wage mean hours median wage median hours) ///
h2(均值 中位数) h2c(2 2) f(2 1 2 1) sum ///
clab(薪资（美元/小时） 工时（小时/周） 薪资（美元/小时） 工时（小时/周）) ///
lwidth(20) cwidth(17) units(cm) ///
title(表3：职业、种族与薪资、工时交叉表)

** 二维交叉表（频数）

tabout occupation race married ///
using "$PATH/表4_职业、种族与婚姻情况交叉表.xlsx", ///
replace c(freq col cum) f(0c 1) clab(数量 比例_% 累计比例_%) ///
lwidth(20) cwidth(10) units(cm) ///
font(bold) style(xlsx) title(表4：职业、种族与婚姻情况交叉表)

** 二维交叉表（摘要）

tabout occupation race ///
using "$PATH/表5_职业与种族交叉分类下的薪资情况表.xlsx", ///
replace h1(不同种族的平均薪资（美元/小时）) h1c(4) h3(nil) ///
c(mean wage) f(2) sum ///
font(bold) style(xlsx) title(表5：职业与种族交叉分类下的薪资情况表)


** 相关性分析
svyset _n
label define c_city_label 0 "No" 1 "Yes"
label value c_city c_city_label

tabout race collgrad c_city ///
using "$PATH/表6_居住地与种族、学历的相关性分析表.xlsx", ///
replace style(xlsx) font(bold)  ///
c(row ci) svy stats(chi2) f(3) cisep(-) level(99) ///
clab(频率 99%置信区间) cwidth(15) indent(0) ///
npos(col) nlab(样本量) h2c(2 2 1) ///
title(表6：居住地与种族、学历的相关性分析表)
*/


* 2. estout

** 最基本的回归分析表
eststo clear
sysuse auto, clear
eststo: quietly regress price weight mpg
eststo: quietly regress price weight mpg length
eststo: quietly regress price weight mpg length foreign
esttab

** 加入回归的其他返回值
esttab, stats(r2 N, labels("R Square" "Num of Obs"))
esttab, ar2
esttab, stats(r2_a N)

** 显示变量标签
esttab, ar2 label
esttab, stats(r2_a N, labels("Adj. R-squ." "Num of Obs")) label

** 输出至文件
global PATH = "D:/PKU-Zyf/R&STATA/tabs" // 这里输入自己的工作路径
esttab using "$PATH/estout_tab_1.xls", ar2 label replace

** 回归表格的较高质量输出
estout using "$PATH/estout_tab_2.xls", ///
    stats( ///
        r2_a N, ///
        labels("Adj. R-sq." "Num of Obs") ///
    ) label replace

** 加入更多要素
estout using "$PATH/estout_tab_3.xls", ///
    cells(b(star)) ///
    stats(r2_a N, ///
        labels("Adj. R-sq." "Num of Obs")) ///
    postfoot("* p<0.05, ** p<0.01, *** p<0.001") ///
    label replace
*/


* 3. outreg

clear
global PATH = "D:/PKU-Zyf/R&STATA/tabs"
sysuse auto, clear
eststo A: quietly regress price weight mpg
eststo B: quietly regress price weight mpg length
eststo C: quietly regress price weight mpg ///
    length foreign
outreg2 [A B C] using "$PATH/outreg2_tab_1.doc", ///
    replace tstat ///
    e(all) bdec(3) tdec(2) ctitle(price)
outreg2 [A B C] using "$PATH/outreg2_tab_2.doc", ///
    replace tstat label ///
    e(N r2_a) bdec(3) tdec(2) ctitle(price)
*/


* 4. asdoc

** 描述统计
clear
global PATH = "D:/PKU-Zyf/R&STATA/tabs"
sysuse auto, clear
asdoc sum price mpg rep78 headroom, label replace save($PATH/asdoc_tab_1.doc)

** 相关性分析
asdoc pwcorr price headroom mpg displacement, sig label replace ///
    save($PATH/asdoc_tab_2.doc) title(Correlation Table)

** 回归分析
asdoc reg price mpg rep78, save($PATH/asdoc_tab_3.doc) label nest replace
asdoc reg price mpg rep78 headroom, label nest append
asdoc reg price mpg rep78 headroom weight, label nest append


* 5. 图片的保存和导出

clear
global PATH = "D:/PKU-Zyf/R&STATA/graphs"
sysuse auto, clear
twoway (scatter price length) (lfit price length), name(my_graph, replace)
graph save my_graph "$PATH/my_graph.gph"
graph export "$PATH/my_graph.png", name(my_graph) as(png) replace
*/

