#!/bin/bash

if [[ -z $2 ]]; then
  LINES=3
else
  LINES=$2
fi

TOTALLINES=$(cat "$1" | wc -l)

if [[ $TOTALLINES -le $((2 * LINES)) ]];
then
  cat "$1"
else
  echo "The first $LINES and last $LINES lines."
  head -n "$LINES" "$1"
  echo "..."
  tail -n "$LINES" "$1"
fi
