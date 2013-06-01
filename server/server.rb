require "fileutils"
require "sinatra"
require 'digest/sha1'
require_relative "../lib/cube_renderer"

get "/cube/:alg" do
  FileUtils.mkdir("tmp") unless Dir.exist?("tmp")
  scramble = params[:alg].gsub("'","PRIME")
  fname = Digest::SHA1.hexdigest(scramble)
  unless File.exist? fname
    CubeRenderer.new(params[:alg]).draw("tmp/#{fname}.png")
  end
  send_file("tmp/#{fname}.png")
end
