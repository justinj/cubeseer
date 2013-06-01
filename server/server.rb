require "fileutils"
require "sinatra"
require 'digest/sha1'
require_relative "../lib/cube_renderer"

get "/cube/:alg" do
  FileUtils.mkdir("tmp") unless Dir.exist?("tmp")
  fname = params[:alg].gsub("'","PRIME")
  fname = Digest::SHA1.hexdigest(fname)
  CubeRenderer.new(params[:alg]).draw("tmp/#{fname}.png")
  send_file("tmp/#{fname}.png")
end
