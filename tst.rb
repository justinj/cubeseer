#!/usr/bin/env ruby

require "mini_magick"
require "pry"

`convert -size 200x200 xc:white canvas.jpg`
image = MiniMagick::Image.open("canvas.jpg")

image.combine_options do |c|
  c.fill "blue"
  c.stroke "black"
  c.strokewidth "5"
  c.draw "rectangle 25,25 100,100"
  p c.command
end

image.write "output.jpg"

image.resize('100x100')
