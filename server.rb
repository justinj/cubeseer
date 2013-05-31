require "fileutils"
require "sinatra"
require_relative "lib/cube_renderer"

get "/" do
  %(<a href="/cube/RUR'">pew</a>)
end

get "/cube/:alg" do
  FileUtils.mkdir("tmp") unless Dir.exist?("tmp")
  CubeRenderer.new(params[:alg]).draw("tmp/#{params[:alg]}.png")
  send_file("tmp/#{params[:alg]}.png")
end
