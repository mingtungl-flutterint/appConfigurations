# print-lines-b4-and-after-matched.awk

# print x=3 lines b4 and y=2 lines after the matched pattern
# gawk -v p="SAVED" -f '.\awk\print-lines-b4-and after-matched.awk' x=3 y=2 .\test.txt
# gawk -v p="SAVED" '/p/{for(i=0;i<x;i++)print a[i];print;for(i=0;i<y;i++) {getline;print}} {a[NR%x]=$0}' x=3 y=2 input.file

# grep -B 3 -A 2 pattern input.file

BEGIN {}
$0 ~ p {for(i=0;i<x;i++)print a[i];print;for(i=0;i<y;i++) {getline;print}} {a[NR%x]=$0}

END{}