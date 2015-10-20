#!/bin/bash
# loop script

COUNT=10
> "$BASHDIR/workspace-cli6/count.txt"
while (( COUNT > 0 ))
do
  echo -e "This is count: $COUNT" >> "$BASHDIR/workspace-cli6/count.txt"
  sleep 3
  (( COUNT -- ))
done