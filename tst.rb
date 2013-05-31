#!/usr/bin/env ruby

require "quick_magick"

i = QuickMagick::Image.solid(100, 100, :white)
i.fill = "blue"
i.draw_rectangle(0, 0, 50, 50)
out_filename = File.join(".", "line_test.gif")
i.save out_filename
