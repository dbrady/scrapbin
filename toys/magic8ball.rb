#!/usr/bin/env ruby

# Does exactly what you think it would do. Originally intended to
# become a chat bot responder for our Campfire room (responds to any
# message =~ /.*\?$/), but meh. We found as much enjoyment by just
# running it by hand and pasting it.
# 
# Yeah, it's crap. But at least I submitted something. :-)
# 
# David Brady - dbrady_jafh@shinybit.com

srand(Time.now.to_i)

ray = ["As I see it, yes",
"Ask again later",
"Better not tell you now",
"Cannot predict now",
"Concentrate and ask again",
"Don't count on it",
"It is certain",
"It is decidedly so",
"Most likely",
"My reply is no",
"My sources say no",
"Outlook good",
"Outlook not so good",
"Reply hazy, try again",
"Signs point to yes",
"Very doubtful",
"Without a doubt",
"Yes",
"Yes - definitely",
"You may rely on it"]

puts ray[rand(ray.size)]
