require "fileutils"
require "quick_magick"
require_relative "cube"

class CubeRenderer
  attr_reader :cube, :size

  attr_accessor :image

  def initialize(alg, size = 3)
    @cube = Cube.algorithm(size, alg)
    @size = size
    @image = nil
  end

  def draw(filename)
    @image = QuickMagick::Image.solid(image_width, image_height, :white)
    render
    image.save filename
  end

  private

  def render
    render_top_stickers
    render_around
  end

  def render_top_stickers
    rows = cube["UBL:UFR"]
    0.upto(size - 1) do |x|
      0.upto(size - 1) do |y|
        color = sticker_to_color rows[y][x]
        render_sticker(x * cubie_width + offset + 1, y * cubie_height + offset + 1, cubie_width, cubie_height, color)
      end
    end
  end

  def render_around
    render_horizontal(cube["FUL:FRU"][0]        , offset + height + side_distance)
    render_horizontal(cube["BUR:BLU"][0].reverse, offset - side_thickness - side_distance)
    render_vertical(  cube["RUF:RBU"][0].reverse, offset + width + side_distance)
    render_vertical(  cube["LUB:LFU"][0]        , offset - side_thickness - side_distance)
  end
  
  def sticker_positions
    (0...size).map do |i| 
      offset + cubie_width * i + side_squishedness
    end
  end

  def render_horizontal(stickers, y)
    stickers.zip(sticker_positions).each do |(face, x)|
      render_sticker(x, y, cubie_width - side_squishedness * 2, side_thickness, sticker_to_color(face))
    end
  end

  def render_vertical(stickers, x)
    stickers.zip(sticker_positions).each do |(face, y)|
      render_sticker(x, y, side_thickness, cubie_height - side_squishedness * 2, sticker_to_color(face))
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

  def side_distance
    3
  end

  def side_squishedness
    1
  end

  def side_thickness
    15
  end

  def render_sticker(x, y, w, h, color)
    render_rect(x, y, w, h, outline_color)
    render_rect(x + outline_thickness, 
                y + outline_thickness, 
                w - outline_thickness * 2, 
                h - outline_thickness * 2, color)
  end

  def render_rect(x,y,w,h,col)
    image.fill = col.to_s
    image.draw_rectangle(x,y,x+w,y+h)
  end

  def outline_thickness
    1
  end

  def outline_color
    :black
  end

  def offset
    (image_height - height)/2
  end

  def width
    200
  end

  def height
    200
  end

  def image_height
    (height * 1.2).floor
  end

  def image_width
    (width * 1.2).floor
  end

  def cubie_height
    (height / size).floor
  end

  def cubie_width
    (width / size).floor
  end
end
