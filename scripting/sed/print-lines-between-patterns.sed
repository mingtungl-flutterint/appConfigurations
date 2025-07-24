#!/usr/bin/sed -f

# sed -n '/BEGIN/,/END/p' IN 1>OUT
/\[2020\/03\/09[[:space:]]10:00:10\]/,/\[2020\/03\/09[[:space:]]10:00:22\]/p