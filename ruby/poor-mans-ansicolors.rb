#!/usr/bin/env ruby
# poor-mans-ansicolors - quick case-and-paste functions for your terminal scripts.

def normal(string)
  "\033[30m#{string}\033[0m"
end

def bold(string)
  "\033[1m#{string}\033[0m"
end

def dim(string)
  "\033[2m#{string}\033[0m"
end

# ansi_colors = {
#   black: { fg: 30, bg: 40, light_fg: 90, light_bg: 100 },
#   red: { fg: 31, bg: 41, light_fg: 91, light_bg: 101 },
#   green: { fg: 32, bg: 42, light_fg: 92, light_bg: 102 },
#   yellow: { fg: 33, bg: 43, light_fg: 93, light_bg: 103 },
#   lavender: { fg: 34, bg: 44, light_fg: 94, light_bg: 104 },
#   magenta: { fg: 35, bg: 45, light_fg: 95, light_bg: 105 },
#   cyan: { fg: 36, bg: 46, light_fg: 96, light_bg: 106 },
#   white: { fg: 37, bg: 47, light_fg: 97, light_bg: 107 },
# }

# ansi_colors.each do |color_name, codes|
#   codes.each do |color_type, color_code|
#     method_name = case color_type
#                   when :fg then color_name
#                   when :bg then "on_#{color_name}"
#                   when :light_fg then "light_#{color_name}"
#                   when :light_bg then "on_light_#{color_name}"
#                   end
#     puts <<-RUBY
# def #{method_name}(string)
#   "\\033[#{color_code}m\#{string}\\033[0m"
# end

# RUBY
#   end
# end

def black(string)
  "\033[30m#{string}\033[0m"
end

def on_black(string)
  "\033[40m#{string}\033[0m"
end

def light_black(string)
  "\033[90m#{string}\033[0m"
end

def on_light_black(string)
  "\033[100m#{string}\033[0m"
end

def red(string)
  "\033[31m#{string}\033[0m"
end

def on_red(string)
  "\033[41m#{string}\033[0m"
end

def light_red(string)
  "\033[91m#{string}\033[0m"
end

def on_light_red(string)
  "\033[101m#{string}\033[0m"
end

def green(string)
  "\033[32m#{string}\033[0m"
end

def on_green(string)
  "\033[42m#{string}\033[0m"
end

def light_green(string)
  "\033[92m#{string}\033[0m"
end

def on_light_green(string)
  "\033[102m#{string}\033[0m"
end

def yellow(string)
  "\033[33m#{string}\033[0m"
end

def on_yellow(string)
  "\033[43m#{string}\033[0m"
end

def light_yellow(string)
  "\033[93m#{string}\033[0m"
end

def on_light_yellow(string)
  "\033[103m#{string}\033[0m"
end

def lavender(string)
  "\033[34m#{string}\033[0m"
end

def on_lavender(string)
  "\033[44m#{string}\033[0m"
end

def light_lavender(string)
  "\033[94m#{string}\033[0m"
end

def on_light_lavender(string)
  "\033[104m#{string}\033[0m"
end

def magenta(string)
  "\033[35m#{string}\033[0m"
end

def on_magenta(string)
  "\033[45m#{string}\033[0m"
end

def light_magenta(string)
  "\033[95m#{string}\033[0m"
end

def on_light_magenta(string)
  "\033[105m#{string}\033[0m"
end

def cyan(string)
  "\033[36m#{string}\033[0m"
end

def on_cyan(string)
  "\033[46m#{string}\033[0m"
end

def light_cyan(string)
  "\033[96m#{string}\033[0m"
end

def on_light_cyan(string)
  "\033[106m#{string}\033[0m"
end

def white(string)
  "\033[37m#{string}\033[0m"
end

def on_white(string)
  "\033[47m#{string}\033[0m"
end

def light_white(string)
  "\033[97m#{string}\033[0m"
end

def on_light_white(string)
  "\033[107m#{string}\033[0m"
end
