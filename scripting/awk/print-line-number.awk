# print-line-number.awk

# Command line input:
#	gawk -v pat="2025\/06\04[[:space:]][[:digit:]]*:00:00"
#   gawk '/^\[2025\/06\/05[[:space:]][[:digit:]]*:00:00/ { print NR": "$0; ++_total }'

#
BEGIN {
    #pat="^\[2025/06/05[[:space:]][[:digit:]]*:00:00"
    #pat1="\[2025/06/05 "
    #pat2=".*:00:00\]"
    print "Print line number of " pat1 pat2
}

# Actions/Rules
#{
#	if ($0 ~ /^\[2025\/06\/05[[:space:]][[:digit:]]*:00:00/) { print NR":"$0; ++_total }
#}

#$0 ~ pat { print NR": "$0; ++_total }
$0 ~ /^\[2025\/06\/05[[:space:]][[:digit:]]*:00:00/ { print NR": "$0; ++_total }

END {
    print "Total: " _total
}