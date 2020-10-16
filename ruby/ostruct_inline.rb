# 2018-06-27 - How to inline ostruct
require 'ostruct'

# Dave had been doing Struct with explicit classes, even when he didn't need the
# class in the first place, like so:
Status = Struct.new :code, :message
status = Status.new 500, "Poop"
status.code

# And John Marks showed him how to one-line it like so:
status = OpenStruct.new status: 500, message: "Better poop"
status.code
