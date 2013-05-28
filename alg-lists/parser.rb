#!/usr/bin/env ruby

require_relative "../lib/cube_renderer"

list = ARGF.read.split("\n")

list.map! do |pair|
  if pair.start_with?("#")
    nil
  else
    pair.split(/\s*:\s*/)
  end
end

list.compact!

list.each do |(name, alg)|
  CubeRenderer.new(alg).draw("#{name}.png")
end
