#!/bin/sh
echo '----------------------------------------'
echo "Creating three text files..."
echo "touch 'foo bar.txt'"; touch "foo bar.txt"
echo "touch 'foo.txt'"; touch "foo.txt"
echo "touch 'bar.txt'"; touch "bar.txt"

echo '----------------------------------------'
echo 'for f in *.txt; do echo $f; done'
for f in *.txt; do echo $f; done

echo '----------------------------------------'
echo 'ls *.txt | while read f; do echo $f; done'
ls *.txt | while read f; do echo $f; done
echo '----------------------------------------'

# echo "Cleaning up text files..."
# echo "rm 'foo bar.txt'"; rm "foo bar.txt"
# echo "rm 'foo.txt'"; rm "foo.txt"
# echo "rm 'bar.txt'"; rm "bar.txt"
