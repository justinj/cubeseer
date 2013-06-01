require "fileutils"
require "sinatra"
require 'digest/sha1'
require_relative "../lib/heise_expander"
require_relative "../lib/cube_renderer"

get "/cube/:alg" do
  make_for_scramble(params[:alg])
end

get "/heise/:alg" do
  make_for_scramble(HeiseExpander.new.expand(params[:alg]))
end

def make_for_scramble(scramble)
  FileUtils.mkdir("tmp") unless Dir.exist?("tmp")
  scramble_filename = scramble.gsub("'","PRIME")
  fname = Digest::SHA1.hexdigest(scramble_filename)
  unless File.exist? fname
    CubeRenderer.new(scramble).draw("tmp/#{fname}.png")
  end
  send_file("tmp/#{fname}.png")
end
