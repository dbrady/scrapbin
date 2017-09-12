#!/usr/bin/env ruby

# Circuit Scramble - Android App that presents you with a circuit. Your task is
# to determine which inputs to turn on or off and which switches to throw in
# order to turn all of the outputs on and enable the "Level Complete" sign.

# Here's a simple one:

#            +-----+
# 1.  o------|     |
#            | AND |---->[ Level Complete ]
# 2.  o------|     |
#            +-----+
#
# Solution: 1, 2

# So the main problem with solving these puzzles with a script will not be
# writing a dingbat to try all the switches and see which solution is the
# shortest and easiest. The main problem will be representing the board in
# text. For example, level 90 is MUCH more complicated:

# 8 inputs
# 12 Gates: 4 OR, 5 AND, 3 XOR
# 6 Inverters
# 2 Switches

# I want to label the gates as O1, O2, etc for OR gates and such, BUT with 8
# inputs and 20 components it gets really hard to know if I've drawn the circuit
# correctly. So instead let's divide the circuit up into ranks. Let's not do a
# true grid because the left/right position is pretty sloppy, so we'll number
# the devices left to right in their rank. So the first row has an XOR all the
# way on the left and an OR gate all the way on the right; until/unless we get
# more than 9 ranks or inputs we can name our components "AYX" where A is the
# type of component (A=AND, O=OR, X=XOR, I=Inverter, S=Switch), then Y is the
# row it lives on and X is the position left-to-right. So our first two devices
# would bo X11 and O12.
#
# One special component, LC, means the Level Complete gate. When all inputs to
# the Level Complete component are high, the level is in fact complete.
#
# Theoretically, gates have 2 inputs and 1 output, switches have 1 input and 2
# outputs, and inverters have 1 input and 1 output. BUT! Circuit traces can
# touch, so any output can be split to go into multiple inputs. Note that
# multiple outputs CANNOT be combined on account of in the real world if one
# goes high and the other goes low it would blow up the circuit by dumping the
# power rail directly to ground. UNTIL we see switches having their outputs
# split, we will assume that if a device has multiple outputs, they are combined
# except in the case of switches which must have exactly two outputs. On the
# other hand, if more than one device feed into a component, we will always
# assume it has multiple different inputs. (Alternately we could have switches
# use a more complicated notation like s51: i61 / x62, a63

# I'm going to describe the graph in single edges, listing each component and
# then each output.
#
# # Rank 0: Inputs
# 1: x11
# 2: x11
# 3: o31
# 4: a32
# 5: a32
# 6: o33
# 7: o12
# 8: o12
#
# # Rank 1:
# x11: i21, o41
# o12: o33, a44
#
# # Rank 2: inverters
# i21: o31
#
# # Rank 3: mostly splitters
# o31: o41, a42
# a32: a42, x43
# o33: x43, a44
#
# # Rank 4:
# o41: a71
# a42: s51
# x43: s52
# a44: a73
#
# # Rank 5: switches
# s51: i61, i62
# s52: i63, a73
#
# # Rank 6: inverters
# i61: a71
# i62: x72
# i63: x72
#
# # Rank 7:
# a71: LC
# x72: i81
# a73: LC
#
# # Rank 8: one last eff you
# i81: LC

# Phew! No way I'm writing all THAT out on a command line, grr! I mean, I
# suppose I could do it in a sort of bareword json approach, like
# "[1:x11,2:x11,...,s51:[i61,i62],...]" or something. Dunno.

# Output: I'd love to make this thing draw text pictures, I really would. And
# given the nature of circuit diagrams I know it would in fact be possible. I
# just also think they'd be huge--level 90 for example would probably be at
# least 50 rows tall. At 3 rows per component plus 3 rows for connectors, the
# middle of L90 might look like this:

# +-----+   +-----+   +-----+   +-----+
# | OR  |   | AND |   | XOR |   | AND |
# +-----+   +-----+   +-----+   +-----+
#   | |       | |       | |       | |
#   | +---+---+ +---+---+ +---+---+ |
#   |     |         |         |     |
#   |  +-----+   +-----+   +-----+  |
#   |  | OR  |   | AND |   | OR  |  |
#   |  +-----+   +-----+   +-----+  |
#   |    | |       | |       | |    |

# ...but even here we run into a problem; we need to spread the inputs to the
# firs OR gate so we can fit an INV on its left input. So we need more like 5
# rows there to do something like

#   |  +-----+   +-----+   +-----+  |
#   |  | OR  |   | AND |   | OR  |  |
#   |  +-----+   +-----+   +-----+  |
#   |    | |       | |       | |    |
#   |    | +----+  | |       | |    |
#   |    |      |  | |       | |    |
#   | +-----+   |  | |       | |    |
#   | | INV |   |  | |       | |    |
#   | +-----+   |  | |       | |    |

# and so on. it's probably better to just emit the drawing as an .svg if we're
# going to play that game.

# Or maybe you don't get a drawing of the circuit at all. Maybe you run the
# script and just get solution lists, like:
#
# ./circuit_scramble.rb level90.txt
# Solutions:
# 2, 3, S51, 6, 7, 8
# 1, 3, S51, 6, 7, 8

# Validation note: no two devices can share the same number, so if we see a41
# and o41, there is definitely an error in the schematic.
