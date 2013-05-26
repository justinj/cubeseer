require_relative "alg_expander"

class Cube
  attr_reader :size
  attr_accessor :sides

  U = 0
  L = 1
  F = 2
  R = 3
  D = 4
  B = 5

  def initialize(size, alg)
    @size = size
    sticker_count = size * size
    @sides = SIDE_NAMES.map { |sticker| [sticker] * sticker_count }
    perform(alg)
  end

  def to_s
    r = single_side(sides[0])
    size.times do |i|
      (1..3).each do |n| 
        r << sides[n].each_slice(size).to_a[i].join 
      end
      r += "\n"
    end
    r += single_side(sides[4])
    r += single_side(sides[5])
  end

  def from_top(n)
    first = n * size
    (first...(first + size)).to_a
  end

  def from_bottom(n)
    from_top(size - n - 1)
  end

  def from_left(n)
    (n...(size*size)).step(size).to_a
  end

  def from_right(n)
    from_left(size - n - 1)
  end

  private

  def perform(alg)
    moves = AlgExpander.new.expand(alg)
    moves.each do |move|
      turn(move)
    end
  end

  def turn(move)
    turn_sides(move)
    turn_face(move)
  end

  def turn_sides(move)
    faces_with_stickers = get_cycle(move).zip(get_indices(move))
    cycles = (0...size).map do |index|
      faces_with_stickers.map { |(face, indices)| [face, indices[index]] }
    end
    perform_cycles(cycles)
  end

  SIDE_FACES = {
    "R"  => [U, B, D, F],
    "L"  => [F, D, B, U],
    "U"  => [R, F, L, B],
    "D"  => [B, L, F, R],
    "F"  => [U, R, D, L],
    "B"  => [L, D, R, U]
  }

  def get_cycle(move)
    SIDE_FACES.fetch(move)
  end

  def get_indices(move)
    case move[0]
    when "R"
      [from_right(0)] * 4
    when "L"
      [from_left(0)] * 4
    when "U"
      [from_top(0)] * 3 + [from_bottom(0).reverse]
    when "D"
      [from_top(0).reverse] + [from_bottom(0)] * 3
    when "F"
      [
        from_bottom(0),
        from_left(0),
        from_top(0).reverse,
        from_right(0).reverse
      ] 
    when "B"
      [
        from_left(0),
        from_bottom(0).reverse,
        from_right(0).reverse,
        from_top(0)
      ] 
    end
  end
  def turn_face(move)
    face = move[0]
    index = face_index(face)
    sides[index] = rotate_face(sides[index])
  end

  def single_side(side)
    offset + side.each_slice(size).map(&:join).join("\n#{offset}") + "\n"
  end

  def offset
    " " * size
  end

  SIDE_NAMES = ["U", "L", "F", "R", "D", "B"]

  def face_index(face)
    SIDE_NAMES.find_index(face)
  end

  def rotate_face(array)
    result = Array.new(array.count)
    array.each_with_index do |value, i|
      x = i % size
      y = i / size
      new_y = x
      new_x = size - 1 - y
      result[new_x + new_y * size] = value
    end
    result
  end

  def perform_cycles(cycles)
    cycles.each do |cycle|
      perform_cycle(cycle)
    end
  end

  def perform_cycle(cycle)
    # We need to save the last sticker since we'll overwrite
    # it as we go through all the pieces
    last_sticker = sides[cycle.last[0]][cycle.last[1]]

    cycle.each_cons(2).reverse_each do |((from_face, from_index), (to_face, to_index))|
      sides[to_face][to_index] = sides[from_face][from_index]
    end

    sides[cycle.first[0]][cycle.first[1]] = last_sticker
  end

  # def next_n(ary)
  #   (1..n).map { ary.shift.to_s }.join
  # end
end
