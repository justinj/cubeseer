require "minitest/autorun" 
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

  SIDE_NAMES = ["U", "L", "F", "R", "D", "B"]

  def initialize(size, sides=nil)
    @size = size
    sticker_count = size * size
    @sides = sides || SIDE_NAMES.map { |sticker| [sticker] * sticker_count }
  end

  def rep
    new_sides = sides.dup.map(&:dup)
    r = ""

    insert_single_side(new_sides[0], r)
    size.times do
      (1..3).each { |n| r << next_n(new_sides[n], size) }
      r << "\n"
    end
    insert_single_side(new_sides[4], r)
    insert_single_side(new_sides[5], r)

    r
  end

  def get_cycle(move)
    {
      "R"  => [U, B, D, F],
      "L"  => [F, D, B, U],
      "U"  => [R, F, L, B],
      "D"  => [B, L, F, R],
      "F"  => [U, R, D, L],
      "B"  => [L, D, R, U]
    }[move]
  end

  def get_indices(move)
    case move[0]
    when "R"
      [from_right(0)] * 4
    when "L"
      [from_left(0)] * 4
    when "U"
      [from_top(0)] * 3 + [from_bottom(0).reverse]
    when "F"
      [from_bottom(0),
       from_left(0),
       from_top(0).reverse,
       from_right(0).reverse] 
    end
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

  def perform(alg)
    moves = AlgExpander.new.expand(alg)
    moves.inject(dup) do |state, move|
      state.turn(move)
    end
  end

  def turn(move)
    state = turn_sides(move)
    state.turn_face(move)
    state
  end

  def face_index(face)
    SIDE_NAMES.find_index(face)
  end

  def turn_face(move)
    face = move[0]
    index = face_index(face)
    sides[index] = rotate(sides[index])
  end

  def rotate(array)
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

  private

  def turn_sides(move)
    to_cycle = get_cycle(move)
    indices = get_indices(move)[0]

    cycles = to_cycle.zip(get_indices(move))

    cycles = (0...size).map do |index|
      cycles.map { |(face, indices)| [face, indices[index]] }
    end

    perform_cycles(cycles)
  end

  def perform_cycles(cycles)
    result = Cube.new(size, sides.map(&:dup))

    cycles.each do |cycle|
      buffer = result.sides[cycle.last[0]][cycle.last[1]]
      cycle.each_cons(2).reverse_each do |((from_face, from_index), (to_face, to_index))|
        result.sides[to_face][to_index] = result.sides[from_face][from_index]
      end
      result.sides[cycle.first[0]][cycle.first[1]] = buffer
    end
    result
  end

  def next_n(ary, n)
    (1..n).map { ary.shift.to_s }.join
  end

  def insert_single_side(side, str)
    size.times do
      str << " " * size + next_n(side, size) + "\n"
    end
  end
end
