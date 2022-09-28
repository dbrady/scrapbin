# commify args. `$0 a b c d` -> "a, b, c, d"
# first time through loop, files and c expand to empty string.
for file in $@; do
    files="$files$glue$file"
    glue=', '
done

echo $files
