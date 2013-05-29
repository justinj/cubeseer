require "sinatra"
require "cairo"
require_relative "lib/cube_renderer"

get "/cube/:alg" do
  CubeRenderer.new(params[:alg]).draw("generated/#{params[:alg]}.png")
  send_file("generated/#{params[:alg]}.png")
end
