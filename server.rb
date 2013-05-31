require "fileutils"
require "sinatra"
require "cairo"
require_relative "lib/cube_renderer"

get "/" do
  %(<a href="/cube/RUR'">pew</a>)
end

get "/cube/:alg" do
  FileUtils.mkdir("generated") unless Dir.exist?("generated")
  CubeRenderer.new(params[:alg]).draw("generated/#{params[:alg]}.png")
  send_file("generated/#{params[:alg]}.png")
end
