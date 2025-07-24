#!/usr/bin/sed -f

## insert string(str) before PATTERN
# sed 's/\(PATTERN\)/str\1/' INFILE
#OR
# sed 's/PATTERN/str&/' INFILE

## insert string(str) after PATTERN
# sed 's/\(PATTERN\)/\1str/' INFILE
#OR
# sed 's/PATTERN/&str/' INFILE

## insert string(str) before and after PATTERN
# sed 's/\(PATTERN\)/str\1str/' INFILE
#OR
# sed 's/PATTERN/str&str/' INFILE

## Multiple matches: use |
# sed 's_PATTERN1\|PATTERN2_str&_g' INFILE 

## Multiple matches: use -e
# sed -e 's_PATTERN1_str&_g' -e 's_PATTERN2_&str_g' INFILE 

# e.g. --- insert "str" after <GamePlayer>
# sed 's_\(<GamePlayer>\)_\1str_g" INIFLE

# --- INLINE - insert "str" before and after </GamePlayer>
# sed -i 's_\(</GamePlayer>\)_str\1str_g' INFILE