require "fileutils"
require "sinatra"
require 'digest/sha1'
require_relative "../lib/heise_expander"
require_relative "../lib/cube_renderer"

get "/cube" do
  scramble = if params.has_key? "alg"
    params["alg"]
  elsif params.has_key? "heise"
    HeiseExpander.new.expand(params["heise"])
  end

  size = params["size"].to_i || 3

  size = 3 if size > 10

  FileUtils.mkdir("tmp") unless Dir.exist?("tmp")
  scramble_filename = scramble.gsub("'","PRIME")
  fname = Digest::SHA1.hexdigest(scramble_filename)
  unless File.exist? fname
    CubeRenderer.new(scramble, size).draw("tmp/#{fname}.png")
  end
  send_file("tmp/#{fname}.png")
end
