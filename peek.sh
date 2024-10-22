#!/bin/bash

filename=$1

head -n 3 "$filename"
echo "..."
tail -n 3 "$filename"
