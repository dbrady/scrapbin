# Random Tips / TIL Stuff

## git log

* `git log --name-only` is the one I always forget. It shows each commit, but
  also shows the filenames from the commit. (It's called "name only" because of
  the _additional_ data to include, the name is the _only_ thing we want to
  see.) TL;dr don't use this, you want `--stat` instead. See next.
* `git log --stat` will show commits, plus the files that were changed, plus a
  +/- graph of the relative number of additions/deletions to that file

## git status

* `git status --porcelain` will show the current git status in a format that is
  easily consumable by other programs, and is guaranteed to be stable across git
  versions and user customizations. I.e. if this works on your machine right
  now, it will work on _"that guy's"_ machine next year--you know, the coworker
  who uses zshell modded out with custom binaries written in go and lua.

## git ls-files

* `git ls-files -o --exclude-standard` will list all the untracked files in the
  repo. `-o` means show "other" (untracked) files, and `--exclude-standard`
  means "but not files git ignores (whether by being a .git folder or by being
  in the local or global .gitignore files).

* `git ls-files -z | xargs -0` general tip here. When piping to xargs, use -z in
  ls-files and -0 in xargs. This will safely preserve whitespace.

* `git ls-files | while read file; do echo $file...; done` is how I usually get
  around whitespace problems; see previous for the xargs version. Note that this
  version can't use xargs, as it's one file per command loop. If you're only
  going to memorize one of these two commands, pick this one as it works
  anywhere streams of text need to be processed. But if you're willing to
  memorize two things, the `-z/-0` trick is really cool, too. (find does it too,
  but with `-print0` instead of `-z`.)
