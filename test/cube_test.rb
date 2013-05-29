require_relative "../lib/query_cube"

class QueryTest < Minitest::Test
  def assert_query query, expected, message=nil
    assert_equal expected, cube.query(query), message
  end
end


class TestNonStandardMoves < MiniTest::Test
  
  def test_F
    assert_equal Cube.algorithm(3, "F")["LUB:LDF"], [
                  [:L, :L, :D],
                  [:L, :L, :D],
                  [:L, :L, :D]]
  end

  def test_Rw
    assert_equal Cube.algorithm(3, "Rw")["UBL:UFR"], [
                  [:U, :F, :F],
                  [:U, :F, :F],
                  [:U, :F, :F]]
  end

  def test_slices
    assert_equal Cube.algorithm(3, "M")["UBL:UFR"], [
                  [:U, :B, :U],
                  [:U, :B, :U],
                  [:U, :B, :U]]
    assert_equal Cube.algorithm(3, "M2")["UBL:UFR"], [
                  [:U, :D, :U],
                  [:U, :D, :U],
                  [:U, :D, :U]]
    assert_equal Cube.algorithm(3, "S")["UBL:UFR"], [
                  [:U, :U, :U],
                  [:L, :L, :L],
                  [:U, :U, :U]]
    assert_equal Cube.algorithm(3, "E")["UBL:UFR"], [
                  [:U, :U, :U],
                  [:U, :U, :U],
                  [:U, :U, :U]]
  end
end
