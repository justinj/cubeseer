require_relative "test_helper"

module CubeSeer
  class AlgInverterTest < Minitest::Test
    def test_blank
      assert_equal "", AlgInverter.new.invert("")
    end

    def test_single_move
      assert_equal "R", AlgInverter.new.invert("R'")
    end

    def test_double_move
      assert_equal "R2", AlgInverter.new.invert("R2")
    end

    def test_multiple_moves
      assert_equal "R' U", AlgInverter.new.invert("U' R")
    end
  end
end
