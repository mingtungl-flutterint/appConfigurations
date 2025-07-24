# print-lines-from-start-to-pattern
# gawk 'BEGIN{f=1} f; /pattern/{f=0}'
#
BEGIN { f=1 }
0 != f { print $0 }
$0 ~ p { f=0 }

