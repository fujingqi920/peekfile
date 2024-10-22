#!/bin/bash

filename=$1
lines=$2

head -n $lines "$filename"
echo "..."
tail -n $lines "$filename"
