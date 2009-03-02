#!/usr/bin/env jruby

include Java
import java.io.ByteArrayInputStream
import javax.imageio.ImageIO
import javax.swing.JFrame

# Clipping
@maxy = 200000
idx = ARGV.index('-c') || ARGV.index('--clip')

if idx
  ARGV.delete_at idx
  @maxy = ARGV[idx].to_i
  ARGV.delete_at idx
end

@interval = 30
@infile = ARGV[0]

@date = Time.now.strftime("????-??-??")
if @infile =~ /(20\d\d-\d\d-\d\d)/
   @date = $1
end

class ImagePanel < javax.swing.JPanel
  def initialize(image, x=0, y=0)
    super()
    @image, @x, @y = image, x, y
  end

  def getPreferredSize
    java.awt.Dimension.new(@image.width, @image.height)
  end

  def paintComponent(graphics)
    graphics.draw_image(@image, @x, @y, nil)
  end
end

require 'rubygems'
gem 'rmagick4j'
gem 'gruff'
require 'gruff'

g = Gruff::Line.new("1600x900")
g.title = "Queue Size on #{@date}"

data = IO.readlines(@infile).map {|line| d = line.split; [d[1].to_i, d[4][0..-2]]}
size = []
labels = { }
@hour = nil
1.upto(data.size-1) do |i|
  if i % @interval == 0
    v = data[i][0]
    size << [v, @maxy].min
    hour = data[i][1][0..1]
    if hour != @hour
      @hour = hour
      labels[size.size-1] = hour
    end
  end
end
g.labels = labels

g.data("count(*) from market_queue_items", size)

image = ImageIO.read(ByteArrayInputStream.new(g.to_blob.to_java_bytes))
frame = JFrame.new("Queue Size")
frame.set_bounds 0, 0, image.width + 20, image.height + 40
frame.add(ImagePanel.new(image, 10, 10))
frame.visible = true
