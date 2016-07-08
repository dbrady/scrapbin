#!/bin/bash
# Just a quick script showing how to assign temporary vars and do simple arithmetic in bash.

date1=$(date +"%s")

echo "Started doing something at $(date -r $date1 +'%F %T')..."

echo "(Example script sleeping for 5 seconds...)"
sleep 5

date2=$(date +"%s")
echo "Finished doing something at $(date -r $date2 +'%F %T')..."

diff=$(($date2-$date1))
echo "Finished doing that thing in $(($diff / 60)) minutes and $(($diff % 60)) seconds."
say "Finished doing that thing in $(($diff / 60)) minutes and $(($diff % 60)) seconds."
