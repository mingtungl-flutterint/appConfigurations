#!/usr/bin/sed -f

# delete texts between PATTERNs

## @set PATTERN1=2020\/09\/24[[:space:]][[:digit:]]*:00:00
## @set PATTERN2=2020\/09\/24[[:space:]][[:digit:]]*:00:00

##  delete texts between 2 pattern excluding lines containing  the patterns
##  sed -i '/PATTERN-1/PATTERN-2/{//!d}' input.file
/PATTERN1/PATTERN2/{//!d}

##  delete texts between 2 pattern including lines containing  the patterns
##  sed -i '/PATTERN-1/PATTERN-2/d' input.file
/PATTERN1/PATTERN2/d