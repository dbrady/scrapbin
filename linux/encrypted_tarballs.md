# Encrypted Tarballs
Credit to
[commandlinefu.com](http://www.commandlinefu.com/commands/view/2134/encrypted-tarballs)

## Creating

`tar -cf - folder/ | gpg -c  > folder.tpg`

## Extracting

`gpg < folder.tpg | tar -xf -`
