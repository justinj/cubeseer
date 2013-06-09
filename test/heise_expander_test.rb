require_relative "test_helper"

module CubeSeer
  class HeiseExpanderTest < Minitest::Test
    def assert_expands_to(expected, moves)
      assert_equal expected,
        HeiseExpander.new.expand(moves)
    end

    def test_nothing
      assert_expands_to "", ""
    end

    def test_single_move
      assert_expands_to "R", "i"
      assert_expands_to "R'", "k"
      assert_expands_to "Rw", "u"
    end

    def test_multiple_moves
      assert_expands_to "F R U", "hij"
      assert_expands_to "R U R' U'", "ijkf"
    end
  end
end
