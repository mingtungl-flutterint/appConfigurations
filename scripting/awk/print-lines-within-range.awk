#!/bin/awk -f
# print-lines-within-range.awk

# awk -v start_idx="10" -v end_idx="100" -f print-lines-within-range.awk

BEGIN {
    #count = 0
    s = start_idx ""
    e = end_idx ""
    if (start_idx == 0) { s="SOF" }
    if (end_idx == 0) { end_idx = 10000000; e="EOF" }
    print "Print lines between", s, "and", e
}

### Actions/Rules
## Printing the Data Blocks Including Both Boundaries

NR>end_idx { exit }; NR>=start_idx { print NR":", $0; count++ }
#NR<=end_idx && NR>=start_idx { print NR":", $0; count++ }

END {
    print count, "lines printed"
}