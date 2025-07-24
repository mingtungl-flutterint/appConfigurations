#!/usr/bin/sed -f

## insert line(s) before/after PATTERN

## Do not quote patterns
## PATTERN=2020\/09\/24[[:space:]][[:digit:]]*:00:00

# single line before PATTERN
sed '/PATTERN/i #line#' IN

# multi-line before PATTERN
sed '/PATTERN/i #line1#\n-line2-' IN

# single line after PATTERN
sed '/PATTERN/a #line#' IN

# multi-line after  PATTERN
sed '/PATTERN/a #line1#\n-line2-' IN