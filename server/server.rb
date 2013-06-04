require "fileutils"
require "sinatra"
require 'digest/sha1'
require_relative "../lib/heise_expander"
require_relative "../lib/cube_renderer"

get "/cube" do
  scramble = get_scramble(params)
  opts = {}
  opts[:alg] = scramble
  opts[:colors] = params["colors"]
  opts[:size] = params["size"].to_i
  create_image(opts)
end

def get_scramble(params)
  if params.has_key? "alg"
    params["alg"]
  elsif params.has_key? "heise"
    CubeSeer::HeiseExpander.new.expand(params["heise"])
  end
end

def create_image(opts)
  FileUtils.mkdir("tmp") unless Dir.exist?("tmp")
  scramble_filename = opts.to_s + opts[:alg].gsub("'","PRIME")
  fname = Digest::SHA1.hexdigest(scramble_filename)
  unless File.exist? fname
    CubeSeer::CubeRenderer.new(opts).draw("tmp/#{fname}.png")
  end
  send_file("tmp/#{fname}.png")
end
