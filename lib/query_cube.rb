require_relative "alg_expander"

class Cube
  class << self
    def algorithm(size, alg)
      moves = AlgExpander.new.expand(alg)
      cube = new(size)
      moves.each { |move| cube.do_move move }
      cube
    end
  end

  attr_reader :size
  attr_reader :sides
  private :sides

  def initialize(size)
    @size = size
    @sides = {
      U: make_face(:U),
      D: make_face(:D),
      L: make_face(:L),
      R: make_face(:R),
      F: make_face(:F),
      B: make_face(:B)
    }
  end

  def make_face(side)
    [[side] * size] * size
  end

  def do_move(move)
    move_face = move[0].to_sym
    move_depth = turn_depth(move)
    affected_sides = ADJACENTS[move_face]
    to_cycle = affected_sides.map { |face| sides[face] }

    # each face that is affected must be rotated so the stickers
    # that cycle are on top
    amount_to_rotate = affected_sides.map {|side| 
      4 - ADJACENTS[side].find_index(move_face) }

    to_cycle = rotate_each(to_cycle, amount_to_rotate)

    cycle_top(to_cycle, move_depth)

    # rotate back
    amount_to_rotate.map! { |x| 4 - x }
    to_cycle = rotate_each(to_cycle, amount_to_rotate)

    # reassign the faces
    affected_sides.zip(to_cycle).each do |(side, face)|
      sides[side] = face
    end

    sides[move_face] = rotate_face_clockwise(sides[move_face])
  end

  def turn_depth(move)
    move.end_with?("w") ? 1 : 0
  end

  def rotate_each(to_rotate, amounts)
    to_rotate.zip(amounts).map do |(side, amount)|
      rotate_face_clockwise(side, amount)
    end
  end

  def cycle_top(faces, depth)
    0.upto(depth) do |i|
      buffer = faces.last[i]
      faces.each_cons(2).reverse_each do |(from, to)|
        to[i] = from[i]
      end
      faces.first[i] = buffer
    end
  end

  CORNERS = [[0,0], [1,0], [1,1], [0,1]]

  # the adjacent faces in the order they match up with the corners
  ADJACENTS = {
    U: %i(B R F L),
    D: %i(F R B L),
    L: %i(U F D B),
    R: %i(U B D F),
    F: %i(U R D L),
    B: %i(U L D R)
  }

  def query(q)
    pieces = q.split(":").map { |piece| faces(piece) }
    raise "query includes multiple faces" if pieces[0][0] != pieces[1][0]
    face = pieces[0][0]
    coords = pieces.map { |(face, adjacent)| sticker_coords(face, adjacent) }
    box_from(coords[0], coords[1], face)
  end
  alias_method :"[]", :query

  def box_from(top_left, bottom_right, face)
    side = sides[face]
    until top_left == [0,0]
      side         = rotate_face_clockwise(side)
      top_left     = rotate_point_clockwise(top_left)
      bottom_right = rotate_point_clockwise(bottom_right)
    end
    box_from_top_left_corner(bottom_right[0], bottom_right[1], side)
  end

  def rotate_face_clockwise(face, times=1)
    times.times { face = face.transpose.map(&:reverse) }
    face
  end

  def rotate_point_clockwise(point)
    [size - 1 - point[1], point[0]]
  end

  def box_from_top_left_corner(width, height, side)
    (0..height).map { |row| side[row][0..width] }
  end

  def faces(piece)
    [piece[0].to_sym, piece[1].to_sym]
  end

  def sticker_coords(face, adjacent)
    index = get_corner_index(face, adjacent)
    coords_for(index)
  end

  def get_corner_index(face, adjacent)
    ADJACENTS[face].find_index(adjacent)
  end

  def coords_for(index)
    row, column = CORNERS[index]
    row *= size - 1
    column *= size - 1
    [row, column]
  end
end
