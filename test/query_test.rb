require "minitest/autorun"

require_relative "../lib/cube"

class QueryTest < Minitest::Test
  def cube
    raise "subclasses must implement this with the cube they want"
  end

  def assert_query query, expected
    assert cube.query(query) == expected
  end
end

class TestQueryOnSolvedCube < QueryTest
  def cube
    Cube.new(3, "")
  end

  def test_single_stickers
    assert_query "ULF", :U
    assert_query "UFR", :U
    assert_query "URB", :U
    assert_query "UBL", :U
    assert_query "UBL:UBL", [[:U]]
  end

  def test_entire_face
    assert_query "UBL:UFR", [
      [:U, :U, :U],
      [:U, :U, :U],
      [:U, :U, :U]]   
  end

  def test_row
    assert_query "ULF:UFR" [[:U, :U, :U]]
  end
end

class TestQueryOnUnsolvedCube < QueryTest
  def cube
    cube.new(3, "R")
  end

  def test_single_stickers
    assert_query "ULF", :U
    assert_query "UFR", :F
    assert_query "URB", :F
    assert_query "UBL", :U
    assert_query "UBL:UBL", [[:U]]
  end

  def test_entire_face
    assert_query "UBL:UFR", [
      [:U, :U, :F],
      [:U, :U, :F],
      [:U, :U, :F]]   
    assert_query "URB:UFR", [
      [:F, :F, :F],
      [:U, :U, :U],
      [:U, :U, :U]]   
  end

  def test_row
    assert_query "ULF:UFR" [[:U, :U, :F]]
    assert_query "UFR:ULF" [[:F, :U, :U]]
  end
end
