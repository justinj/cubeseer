require "sinatra"
require "cairo"
require_relative "lib/cube_renderer"

get "/cube/:alg" do
  CubeRenderer.new(params[:alg]).draw
  send_file("file.png")
end
