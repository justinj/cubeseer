#!/usr/bin/env ruby

require_relative "cube_renderer"

CubeRenderer.new("F R U R' U' F'", :colors => "yxxxxx").draw("result.png")
