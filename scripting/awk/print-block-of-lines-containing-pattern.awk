# print-block-of-lines-containing-pattern.awk

# awk -v pStart="BEGIN" -v pEnd="END" -v pInside="SAVED" -f print-block-of-lines-containing-pattern.awk
# awk 'flag{
#	buf = buf $0 ORS;
#	if (/PatternEnd/ && buf ~ /PatternInside/)
#	   {printf "%s", buf; flag=0; buf=""}
#}
#/PatternStart/{buf = $0 ORS; flag=1}
#END { print ""total" blocks printed" }' file

BEGIN {
    print "Print-block-of-lines-containing-pattern"
    print "BEGIN : " pStart
    print "END   : " pEnd
    print "INSIDE: " pInside
    total = 0
    flag = 0
}

# If the flag is true, subsequent lines are appended to buf
# and once there is a line where PatternEnd matches 
# and the PatternInside finds a match in the buf, 
# the match is printed, buf gets cleared and the flag is reset.
flag {
    buf = buf $0 ORS;
    if ($0 ~ pEnd && buf ~ pInside) { printf "%s", buf; total++; flag=0; buf="" }
}

# finds the line that matches the pStart pattern
# starts writing the output value to buf and sets the flag
$0 ~ pStart{buf = $0 ORS; flag=1}

END {
    print ""total" blocks printed"
}
