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
  create_image_for scramble
end

def create_image_for(scramble)
  FileUtils.mkdir("tmp") unless Dir.exist?("tmp")
  scramble_filename = scramble.gsub("'","PRIME")
  fname = Digest::SHA1.hexdigest(scramble_filename)
  unless File.exist? fname
    CubeRenderer.new(scramble).draw("tmp/#{fname}.png")
  end
  send_file("tmp/#{fname}.png")
end
