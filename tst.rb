#!/usr/bin/env ruby

require "mini_magick"
require "pry"

`convert -size 200x200 xc:white canvas.jpg`
image = MiniMagick::Image.open("canvas.jpg")

image.write "output.jpg"

image.resize('100x100')
