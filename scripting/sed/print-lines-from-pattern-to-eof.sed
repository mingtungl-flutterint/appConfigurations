#!/usr/bin/sed -f

## print lines from PATTERN to end of file

# PATTERN=\[2020\/03\/09[[:space:]]10:40:22\]

#sed -n '/^PATTERN/,$p' IN 1>OUT
/PATTERN/,$p