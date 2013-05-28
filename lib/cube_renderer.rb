require "cairo"
require_relative "cube"

class CubeRenderer
  attr_reader :cube, :size

  def initialize(alg, size = 3)
    @cube = Cube.new(size, alg)
    @size = size
  end

  def draw(filename)
    @surface = Cairo::SVGSurface.new("tempsvg.svg", image_width, image_height)
    @cr = Cairo::Context.new(@surface)
    create_scene
    render
    @cr.target.write_to_png(filename)
    @cr.target.finish
  end

  private

  def create_scene
    @cr.set_source_color(background_color)
    @cr.paint
  end

  def background_color
    :white
  end

  def render
    render_top_stickers
    render_side_stickers
  end

  def render_top_stickers
    0.upto(size - 1) do |x|
      0.upto(size - 1) do |y|
        render_cubie(x,y)
      end
    end
  end

  def render_side_stickers
    faces = [
      [Cube::B, :top, cube.from_bottom(0)],
      [Cube::R, :right, cube.from_top(0).reverse],
      [Cube::F, :bottom, cube.from_top(0)],
      [Cube::L, :left, cube.from_top(0)]
    ]

              
    faces.each do |(face, side, row)|
      stickers = row.map { |i| cube.sides[face][i] }
      colors = stickers.map { |sticker| sticker_to_color(sticker) }
      colors.each_with_index do |color,i|
        render_side(i, side, color)
      end
    end
  end

  def sticker_to_color(sticker)
    case sticker
    when "U"
      :white
    when "F"
      :green
    when "R"
      :red
    when "L"
      :orange
    when "D"
      :yellow
    when "B"
      :blue
    end
  end

  def render_side(index, side, color)

    x = x_offset + 
      case side
        when :left
          -(side_distance + side_thickness)
        when :right
          height + side_distance
        else
          index * cubie_width + side_squishedness
        end

    y = y_offset + 
      case side
        when :top
          -(side_distance + side_thickness)
        when :bottom
          height + side_distance
        else
          index * cubie_height + side_squishedness
        end

    h = case side
        when :left, :right
          cubie_height - side_squishedness * 2
        else
          side_thickness
        end

    w = case side
        when :top, :bottom
          cubie_width - side_squishedness * 2
        else
          side_thickness
        end

    render_sticker(x: x,
                       y: y, 
                       w: w,
                       h: h,
                       color: color)
  end

  def side_distance
    5
  end

  def side_squishedness
    5
  end

  def side_thickness
    10
  end

  def render_cubie(x,y)
    color = sticker_to_color(cube.sides[Cube::U][x + y * size])
    render_x = x * cubie_width + x_offset
    render_y = y * cubie_height + y_offset

    render_sticker(x: render_x, 
                       y: render_y, 
                       w: cubie_width, 
                       h: cubie_height,
                      color: color)
  end

  def render_sticker(args)
    @cr.rectangle(args[:x], args[:y], args[:w], args[:h])
    @cr.set_source_color(args[:color])
    @cr.fill

    @cr.rectangle(args[:x], args[:y], args[:w], args[:h])
    @cr.set_source_color(outline_color)
    @cr.stroke
  end

  def outline_color
    :black
  end

  def y_offset
    (image_height - height)/2
  end

  def x_offset
    (image_width - width)/2
  end

  def width
    200
  end

  def height
    200
  end

  def image_height
    height * 1.2
  end

  def image_width
    width * 1.2
  end

  def cubie_height
    height / size
  end

  def cubie_width
    width / size
  end

end
