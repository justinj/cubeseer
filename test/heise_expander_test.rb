require_relative "../lib/heise_expander.rb"

class HeiseExpanderTest < Minitest::Test
  def assert_expands_to(expected, moves)
    assert_equal HeiseExpander.new.expand(moves),
      expected
  end

  def test_nothing
    assert_expands_to "", ""
  end

  def test_single_move
    assert_expands_to "R", "i"
    assert_expands_to "R'", "k"
  end

  def test_multiple_moves
    assert_expands_to "F R U", "hij"
    assert_expands_to "R U R' U'", "ijkf"
  end
end
