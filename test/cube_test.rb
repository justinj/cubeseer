require_relative "../lib/cube"

class QueryTest < Minitest::Test
  def assert_query query, expected, message=nil
    assert_equal expected, cube.query(query), message
  end
end


class TestNonStandardMoves < MiniTest::Test
  
  def test_F
    assert_equal [[:L, :L, :D],
                  [:L, :L, :D],
                  [:L, :L, :D]],
                  Cube.algorithm(3, "F")["LUB:LDF"]
  end

  def test_Rw
    assert_equal [[:U, :F, :F],
                  [:U, :F, :F],
                  [:U, :F, :F]],
                  Cube.algorithm(3, "Rw")["UBL:UFR"]
  end

  def test_slices
    assert_equal [[:U, :B, :U],
                  [:U, :B, :U],
                  [:U, :B, :U]],
                  Cube.algorithm(3, "M")["UBL:UFR"]
    assert_equal [[:U, :B, :B, :U],
                  [:U, :B, :B, :U],
                  [:U, :B, :B, :U],
                  [:U, :B, :B, :U]],
                  Cube.algorithm(4, "M")["UBL:UFR"]
    assert_equal [[:U, :D, :U],
                  [:U, :D, :U],
                  [:U, :D, :U]],
                  Cube.algorithm(3, "M2")["UBL:UFR"]
    assert_equal [[:U, :U, :U],
                  [:L, :L, :L],
                  [:U, :U, :U]],
                  Cube.algorithm(3, "S")["UBL:UFR"]
    assert_equal [[:U, :U, :U],
                  [:U, :U, :U],
                  [:U, :U, :U]],
                  Cube.algorithm(3, "E")["UBL:UFR"]
  end
  
  def test_rotations
    assert_equal [[:F, :F, :F],
                  [:F, :F, :F],
                  [:F, :F, :F]],
                  Cube.algorithm(3, "x")["UBL:UFR"]
    assert_equal [[:U, :U, :U],
                  [:U, :U, :U],
                  [:U, :U, :U]],
                  Cube.algorithm(3, "y")["UBL:UFR"]
    assert_equal [[:L, :L, :L],
                  [:L, :L, :L],
                  [:L, :L, :L]],
                  Cube.algorithm(3, "z")["UBL:UFR"]
  end

  def test_move_with_rotation
    assert_equal [[:L, :B, :B]],
                  Cube.algorithm(3, "U z")["BUR:BLU"]
  end
end
