#!/usr/bin/env ruby

require_relative "cube_renderer"

module CubeSeer
  CubeRenderer.new(:alg => "F R U R' U' F'", :colors => "yxxxxx").draw("result.png")
end
