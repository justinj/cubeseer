require "cairo"
require "mini_magick"
require_relative "query_cube"

class CubeRenderer
  attr_reader :cube, :size

  attr_accessor :image

  def initialize(alg, size = 3)
    @cube = Cube.algorithm(size, alg)
    @size = size
    @image = nil
  end

  def draw(filename)
    `convert -size #{image_width}x#{image_height} xc:white #{filename}`
    @image = MiniMagick::Image.open(filename)
    render
    image.write(filename)
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
    rows = cube["UBL:UFR"]
    0.upto(size - 1) do |x|
      0.upto(size - 1) do |y|
      color = sticker_to_color rows[y][x]
      render_sticker(x: x * cubie_width + x_offset,
                     y: y * cubie_height + y_offset,
                     w: cubie_width,
                     h: cubie_height,
                     color: color)
      end
    end
  end

  def render_side_stickers
    rows = {
      bottom: cube["FUL:FRU"][0],
      top: cube["BUR:BLU"][0].reverse,
      right: cube["RUF:RBU"][0].reverse,
      left: cube["LUB:LFU"][0]
    }

    rows.each do |(position, stickers)|
      colors = stickers.map { |side| sticker_to_color(side) }
      p colors
      colors.each_with_index do |color,i|
        render_side(i, position, color)
      end
    end
  end

  def sticker_to_color(sticker)
    {
      U: :white,
      F: :green,
      R: :red,
      L: :orange,
      D: :yellow,
      B: :blue
    }[sticker]
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

  def render_sticker(args)
    render_rect(args[:x] - outline_thickness, 
                args[:y] - outline_thickness, 
                args[:w] + outline_thickness * 2, 
                args[:h] + outline_thickness * 2, outline_color)
    render_rect(args[:x], args[:y], args[:w], args[:h], args[:color])
  end

  def render_rect(x,y,w,h,col)
    image.combine_options do |c|
      c.fill col.to_s
      c.draw "rectangle #{x},#{y} #{x + w},#{y + h}"
    end
  end

  def outline_thickness
    1
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
