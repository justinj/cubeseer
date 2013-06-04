require "fileutils"
require "sinatra"
require 'digest/sha1'
require_relative "../lib/heise_expander"
require_relative "../lib/cube_renderer"

get "/cube" do
  scramble = if params.has_key? "alg"
    params["alg"]
  elsif params.has_key? "heise"
    CubeSeer::HeiseExpander.new.expand(params["heise"])
  end

  opts = {}

  opts[:colors] = params["colors"]

  opts[:size] = (params["size"] || 3).to_i
  opts[:size] = 10 if opts[:size] > 10
  opts[:size] = 1 if opts[:size] < 1

  FileUtils.mkdir("tmp") unless Dir.exist?("tmp")
  scramble_filename = opts.to_s + scramble.gsub("'","PRIME")
  fname = Digest::SHA1.hexdigest(scramble_filename)
  unless File.exist? fname
    CubeSeer::CubeRenderer.new(scramble, opts).draw("tmp/#{fname}.png")
  end
  send_file("tmp/#{fname}.png")
end
