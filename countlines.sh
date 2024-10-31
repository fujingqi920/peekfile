#!/bin/bash

for FILE in "$@";do
    NLINES=$(cat "$FILE" | wc -l)

    if [ "$NLINES" -eq 0 ]; then
        echo "The file '$FILE' is empty."
    elif [ "$NLINES" -eq 1 ]; then
        echo "The file '$FILE' has 1 line."
    else
        echo "The file '$FILE' has $NLINES lines."
    fi
done
