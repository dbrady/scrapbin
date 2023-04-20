#!/usr/bin/env ruby
# argf_with_argv.rb - Read contents from stdin AND get FILENAMES from the
# command line.
#
# TL;dr Don't do this. Future me here, coming back to this script 18 months
# later. I was looking for a bog-standard demo of ARGF, and this script gave me
# nothing but a timesink. This is a wildly non-idiomatic approach. Let's call it
# an ABERRANT approach. I completely forgot that this code doesn't do "either"
# but rather does "both". It reads stdin AND tries to determine if cli args are
# existing files, and that failing to detect the file puts us in the ambiguous
# state of not knowing the operator's intent: "did you intend to specify a file
# that exists, but typed it wrong," or "do you intend to give me an argument
# that you know is not a filename". The operator knows but the script does
# not. A further complication is if the operator wishes to specify a
# command-line argument that happens to match an existing filename.
#
# Another point of data: The print_named_list method was unhelpful. It's an
# obvious candidate for DRY, because it's 5LOC repeating 4 times in
# 25LOC. BUT. It's a grunty helper function that just prints a list. In my first
# 1000MPH file scan, I saw "this is a method, it could be important". Then I
# skipped over it and continued scanning the file. What I saw was "do some
# stuff, call that method, do more stuff, call that method, do more stuff, call
# that method". By the time I geared down and started reading for deeper
# comprehension, my mental model of the program was "this method is the
# important part of the script, and the body code below is just setting things
# up over and over to create acceptable parameters for passing to that method."
# It was about this time that I noticed the method began with print_, but I
# stayed on high alert (meaning considering the method to be of high
# importance). (Food for thought here, I have hundreds of tiny triggers for "uh
# oh, red flag, this code is more important than I thought, go to high
# alert/attention"... but I have much fewer triggers for "oh, this is not
# actually important, stand down".
#
# For the record, the previous paragraph is much more detailed and
# painful-sounding than the actual experience. The confusion over this method
# only lasted about 60 seconds. If this were a Rails app or a 50kLOC
# application, it might be well worth the tradeoff. BUT! This is a tiny demo
# script, and I should have been in and out of this entire file in under 20
# seconds. The incurred cost, proportional to the expected outlay, was way too
# high. I am taking the time to document this "tiny but unacceptable cost" for
# Future Me, for when I am writing code and considering DRYing things up. If
# Future Me were to write this code from scratch, I would first consider
# unrolling the 5LOC. And once I saw the print code overwhelm the visual real
# estate of the important code, I would make the important design decision to
# stop trying to prettify the output> I think doing e.g. `puts args.inspect`
# would give acceptable output.
#
# Use this when:
#
# - You need the actual filenames when not reading from stdin. (Ruby's ARGF will
# eat the filenames, which is normally fine because it's consistent with stdin
# have no filename.)
#
# - You need stdin AND filenames (why? This is weird, right?). But yeah, if you
# needed to `cat names.txt | foo.rb phones.txt addresses.txt > contacts.txt` or
# something, ok I guess?
#
# The problem: Ruby's standard ARGF will give you file contents both ways,
# preventing you from seeing the filenames.
#
# Why I Care: For in-place vs stream editing. Sometimes I want `foo | script.rb`
# to output to stdout but I want `script foo.txt` to modify foo.txt in place.
#
# These work the same:
# $ cat pants.txt cheese.txt | ruby argf_with_argv.rb
# $ ruby argf_with_argv.rb pants.txt cheese.txt
#
# TL;dr Ruby's standard ARGF.each_line will let you specify filenames from the
# command line but will automagically open the files for you


# This happens 4 times in this script, it just prints the name of the list and
# then its contents.
#
# 2023-04-05: I revisited this script today, and this tidy little method made
# the script a tiny bit harder to read. Since this a scratch/demo script, I'm
# going to
#
#This is a quick/scratch demo program.
# script a tiny bit harder to read. Imma unroll it, but keep this
def print_named_list(name, list)
  puts "#{name}:"
  list.each.with_index(1) do |arg, index|
    puts "#{index}: #{arg}"
  end
  puts
end

puts "argf_with_argv.rb, here's the breakdown:"
print_named_list "ARGV", ARGV

args_to_delete = ARGV.find_all { |arg| !File.exists?(arg) }
if args_to_delete.any?
  puts "There are some args that exist that are not files. These must be removed:"
  print_named_list "Args to Delete", args_to_delete

  ARGV.delete_if { |arg| !File.exists?(arg) }

  puts "Okay, let's look at ARGV again, then:"
  print_named_list "ARGV", ARGV
end

puts "Now then, if ARGV has any values in it, ARGF will read through them line by line in turn. If ARGV is empty, it will read from STDIN."
print_named_list "ARGF", ARGF
