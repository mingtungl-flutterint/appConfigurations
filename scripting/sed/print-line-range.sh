#!/bin/bash

## print-line-range.sh

if [[ $# -lt 3 ]]; then
    echo "Usage: $0 startIdx endIdx filename"
    exit 1
fi

echo "-- Print lines $1-$2 of $3"
sed -n "$1,$2p" $3

# with line number
#sed -n "$1,$2{=;p}" $3 | sed '{N; s/\n/: /}'