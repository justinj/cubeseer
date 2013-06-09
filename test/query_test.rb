require_relative "test_helper"

module CubeSeer
  class QueryTest < MiniTest::Test
    def cube
      raise "subclasses must implement this with the cube they want"
    end

    def assert_query query, expected, message=nil
      assert_equal expected, cube.query(query), message
    end
  end

  class TestQueryOnSolvedCube < QueryTest
    def cube
      Cube.algorithm(3, "")
    end

    def test_entire_face
      assert_query "UBL:UFR", [
        [:U, :U, :U],
        [:U, :U, :U],
        [:U, :U, :U]]   
    end

    def test_row
      assert_query "UBL:UBL", [[:U]], "single sticker"
      assert_query "UBL:URB", [[:U, :U, :U]], "along back"
      assert_query "ULF:UFR", [[:U], [:U], [:U]], "along front"
      assert_query "URB:UFR", [[:U, :U, :U]], "along right"
    end

  end

  class TestQueryOnU < QueryTest
    def cube
      Cube.algorithm(3, "U")
    end

    def test_entire_face
      assert_query "UBL:UFR", [
        [:U, :U, :U],
        [:U, :U, :U],
        [:U, :U, :U]]   
      assert_query "FUL:FDR", [
        [:R, :R, :R],
        [:F, :F, :F],
        [:F, :F, :F]]   
      assert_query "FRU:FLD", [
        [:R, :F, :F],
        [:R, :F, :F],
        [:R, :F, :F]]   
    end
  end

  class TestQueryOnRU < QueryTest
    def cube
      Cube.algorithm(3, "R U")
    end

    def test_entire_face
      assert_query "UBL:UFR", [
        [:U, :U, :U],
        [:U, :U, :U],
        [:F, :F, :F]]   
    end
  end

  class TestQueryOnR < QueryTest
    def cube
      Cube.algorithm(3, "R")
    end

    def test_entire_face
      assert_query "UBL:UFR", [
        [:U, :U, :F],
        [:U, :U, :F],
        [:U, :U, :F]]   
    end
  end

  class TestQueryOnUprime < QueryTest
    def cube
      Cube.algorithm(3, "U'")
    end

    def test_entire_face
      assert_query "UBL:UFR", [
        [:U, :U, :U],
        [:U, :U, :U],
        [:U, :U, :U]]   
      assert_query "FUL:FDR", [
        [:L, :L, :L],
        [:F, :F, :F],
        [:F, :F, :F]]   
    end
  end
end

  # error cases(?):
  # XYZ : ABC
  # XYZ :ABC
  # XYZ: ABC
  # WXYZ: ABC
  # XYZ: ABC
