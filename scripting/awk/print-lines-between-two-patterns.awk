# print-lines-between-two-patterns.awk

# awk -v pat1="test" -v pat2="SAVED" -f print-lines-between-two-patterns.awk

# DATA_BEGIN=\[2020\/03\/09[[:space:]]10:40:22\]
# DATA_END="\[2020\/03\/09[[:space:]]10:40:30\]

# --------------------------------------------------------------------------------------------------
# ref: https://www.baeldung.com/linux/print-lines-between-two-patterns
# --------------------------------------------------------------------------------------------------

BEGIN {
    print "Print lines between " pat1 " and " pat2
    total = 0
    f = 0
}

### Actions/Rules
## Printing the Data Blocks Including Both Boundaries
$0 ~ pat1, $0 ~ pat2 {
#	print "include_Both_Boundaries: ";
	include_Both_Boundaries()
}


## Printing the Data Blocks Including the “BEGIN” Boundary Only
#$0 ~ pat1, $0 ~ pat2 { 
#	print "include_Begin_Boundary: ";
#	include_Begin_Boundary()
#}


## Printing the Data Blocks Including the “END” Boundary Only
#$0 ~ pat1, $0 ~ pat2 {
#	print "include_End_Boundary: ";
#	include_End_Boundary() 
#}


## Printing the Data Blocks Excluding Both Boundaries
#$0 ~ pat1, $0 ~ pat2 {
#	print "exclude_Both_Boundaries: ";
#	exclude_Both_Boundaries()
#}

END {
    print ""total" lines printed"
}

function include_Both_Boundaries() {
    if ($0 ~ pat1) { f = 1 };
    if (f != 0) { total++; print $0 }
    if ($0 ~ pat2) { f = 0;  next }
}

function include_Begin_Boundary() {
    if ($0 ~ pat1) { f = 1 };
    if ($0 ~ pat2) { f = 0;  next }
    if (f != 0) { total++; print $0 }
}

function include_End_Boundary() {
    if ($0 ~ pat1) { f = 1; next }
    if ($0 ~ pat2) { f = 0; print $0; total++; next }
    if (f != 0) { print $0; ++total; }
}

function exclude_Both_Boundaries() {
    if ($0 ~ pat1) { f = 1; next }
    if ($0 ~ pat2) { f = 0; next }
    if (f != 0) { print $0; ++total; }
}