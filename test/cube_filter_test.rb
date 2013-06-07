require "minitest"
require_relative "../lib/cube_filter"

module CubeSeer
  class FilterTest < Minitest::Test
    def setup
      @cube = Minitest::Mock.new
      @filter = CubeFilter.new
    end

    def test_asks_cube
      @cube.expect :query, nil, [String]
      @filter.cube = @cube
      @filter["UBL:UFR"]

      @cube.verify
    end

    def test_filters_nothing_by_default
      @cube.expect :query, [[:U, :U, :U]], [String]
      @filter.cube = @cube
      assert_equal [[:U, :U, :U]], @filter["UBL:URB"]
    end

    def test_except_filters_edges_row
      @cube.expect :query, [[:U, :U, :U]], [String]
      @filter.cube = @cube
      @filter.show(except: :edges)
      assert_equal [[:U, :X, :U]], @filter["UBL:URB"]
    end

    def test_filters_edges_row
      @cube.expect :query, [[:U, :U, :U]], [String]
      @filter.cube = @cube
      @filter.show(only: :edges)
      assert_equal [[:X, :U, :X]], @filter["UBL:URB"]
    end

    def test_filters_corners_row
      @cube.expect :query, [[:U, :U, :U]], [String]
      @filter.cube = @cube
      @filter.show(only: :corners)
      assert_equal [[:U, :X, :U]], @filter["UBL:URB"]
    end

    def test_filters_centers_row
      @cube.expect :query, [[:U, :U, :U]], [String]
      @filter.cube = @cube
      @filter.show(only: :centers)
      assert_equal [[:X, :X, :X]], @filter["UBL:URB"]
    end

    def test_filters_edges_face
      @cube.expect :query, [[:U, :U, :U],
        [:U, :U, :U],
        [:U, :U, :U]], [String]
      @filter.cube = @cube
      @filter.show(only: :edges)
      assert_equal [[:X, :U, :X],
        [:U, :X, :U],
        [:X, :U, :X]], @filter["UBL:UFR"]
    end

    def test_except_filters_centers_face
      @cube.expect :query, [[:U, :U, :U],
        [:U, :U, :U],
        [:U, :U, :U]], [String]
      @filter.cube = @cube
      @filter.show(except: :centers)
      assert_equal [[:U, :U, :U],
        [:U, :X, :U],
        [:U, :U, :U]], @filter["UBL:UFR"]
    end

    def test_filters_centers_face
      @cube.expect :query, [[:U, :U, :U],
        [:U, :U, :U],
        [:U, :U, :U]], [String]
      @filter.cube = @cube
      @filter.show(only: :centers)
      assert_equal [[:X, :X, :X],
        [:X, :U, :X],
        [:X, :X, :X]], @filter["UBL:UFR"]
    end
  end
end
