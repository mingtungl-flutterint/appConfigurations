#!/usr/bin/sed -f

##  delete lines that matches PATTERN

##  Do not quote patterns
# PATTERN1=2020\/09\/24[[:space:]][[:digit:]]*:00:00
# PATTERN2=2020\/09\/24[[:space:]][[:digit:]]*:00:00
# PATTERN1=MD 20353
# PATTERN2=MD 21032
# PATTERN3=MD 21353

##  delete line matching either pattern 1 or 2
# sed '/PATTERN1/d;/PATTERN2/d;/PATTERN3/d' -i IN
/PATTERN1/d;/PATTERN2/d;/PATTERN3/d