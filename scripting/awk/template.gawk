# gawk profile

# is for comments in Awk
# BEGIN block(s)

BEGIN {
	printf "\n---|Header|--\n"
}

# Rule(s)/ACTION(s) # Action for everyline in a file
{
	# Print line number:
	# Command line input:
	#	gawk -v "pat=2025\/06\04[[:space:]][[:digit:]]*:00:00"

	# Split file
	#Command: gawk -v "pat=%PATTERN%" -v "infile=%INFILE%"
	if ($0 ~ /^pat/) {
		{ x="infile.SPLIT."++i; next }
		{ print > x; }
	}
}

# END block(s)
END {
	printf "\n---|Footer|---\n"
}