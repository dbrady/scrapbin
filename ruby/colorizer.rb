#!/usr/bin/env ruby

# def colorize(string, *colors)
#   color_codes = Hash[*(%w(black red green yellow blue magenta cyan white).map.with_index {|c,i| [c, i+30, "light_#{c}", i+90, "on_#{c}", i+40, "on_light_#{c}", i+100]}.flatten)].tap { it.default = 30 }.merge({"bold"=>1, "dim"=>2})
#   color_code = colors.map { color_codes[it.to_s] }.join(";")
#   "\033[#{color_code}m#{string}\033[0m"
# end

# colorize - ANSI colorize
# ESC[<code>m - set color, background color, bold/dim
def colorize(string, *colors) = "\e[#{colors.map { [['light_', 60], ['on_', 10]].inject(%w[black red green yellow blue magenta cyan white].zip(30..)) { |acc, (prefix, offset)| acc + acc.map { |name, code| [%Q(#{prefix}#{name}), code + offset] } }.to_h.merge('bold'=>1,'dim'=>2)[it.to_s] }.join(';')}m#{string}\e[0m"

if __FILE__ == $0
  color_names = %w(black red green yellow blue magenta cyan white)
  color_codes = %w(BLK RED GRN YEL BLU MAG CYN WHT LBLK LRED LGRN LYEL LBLU LMAG LCYN LWHT )

  color_names2 = color_names.dup + color_names.map { "light_#{it}" }

  color_decodes = Hash[color_names2.zip(color_codes) + color_codes.zip(color_names2)]

  colors = color_names.dup
  colors += colors.map { "light_#{it}" }
  background_colors = colors.map { "on_#{it}" }
  colors = colors + background_colors

  title_bar = "%-14s | %s" % ["FG \\ BG", *((color_names2).map {"%-14s" % it}.join(" "))]
  puts title_bar.gsub(/_/, ' ')
  puts title_bar.gsub(/[^\|]/, '-')
  color_names.each do |color|
    # Normal, light
    [:normal, :light, :bold, :dim].each do |modifier|
      foreground_color = modifier == :light ? "light_#{color}" : color
      foreground_color_name = "#{modifier} #{color}"
      print "%-14s | " % foreground_color_name
      background_colors.each do |background_color|
        color_code = "#{color_decodes[foreground_color].ljust(4)} on #{color_decodes[background_color.sub(/^on_/, '')]}"

        colorizer = [foreground_color, background_color]
        colorizer << modifier if [:bold, :dim].include? modifier

        color_code = colorize(color_code.ljust(14), *colorizer)
        #color_code = colorize(color_code, background_color)
        print color_code + " "
      end
      puts
    end
  end
end
