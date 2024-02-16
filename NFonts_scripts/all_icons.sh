#!/usr/bin/env bash

filenames=`ls -1 i_*.sh`

for i in ${filenames}; do
	# shellcheck source=/dev/null
	test -f $i -a -r $i && source $i
	#test -f "$i" -a -r "$i" && source "$i"
done
unset i
