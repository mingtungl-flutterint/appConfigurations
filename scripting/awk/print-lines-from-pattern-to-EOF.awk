## print-lines-from-pattern-to-EOF

# gawk 'BEGIN { f=0 } f; /pattern/{ f=1 }' INFILE
# gawk -v p="test" - f print-lines-from-pattern-to-EOF INFILE

BEGIN { f = 0 }

$0 ~ p { f=1 }
0 != f { print $0 }