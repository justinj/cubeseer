require "fileutils"
require "sinatra"
require_relative "lib/cube_renderer"

get "/" do
  %(<a href="/cube/RUR'">pew</a>)
end

get "/cube/:alg" do
  FileUtils.mkdir("tmp") unless Dir.exist?("tmp")
  fname = params[:alg].gsub("'","PRIME")
  CubeRenderer.new(params[:alg]).draw("tmp/#{fname}.png")
  send_file("tmp/#{fname}.png")
end
