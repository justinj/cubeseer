require "minitest/autorun"
require "minitest/mock"

module CubeSeer
  class CubeFilter
    attr_accessor :cube

    def initialize
      @filters = []
    end

    def query(q)
      result = cube.query(q)
      @filters.each do |filter|
        result = filter[q, result]
      end
      result
    end
    alias_method :"[]", :query

    def show(args)
      only(args)
    end

    private

    def only(args)
      piece_type = args[:only]
      # todo: this is kind of ugly, figure out a better way
      add_filter do |query, result|
        case piece_type
        when :edges
          filter_on(query, result) { |r, c, s| edge_piece?(r, c, s) }
        when :corners
          filter_on(query, result) { |r, c, s| corner_piece?(r, c, s) }
        when :centers
          filter_on(query, result) { |r, c, s| center_piece?(r, c, s) }
        end
      end
    end

    def filter_on(query, result)
      new_result = []
      result.each_with_index do |row, r|
        new_row = []
        row.each_with_index do |sticker, c|
          if yield(r, c, result)
            new_row << sticker
          else
            new_row << :X
          end
        end
        new_result << new_row
      end
      new_result
    end

    def edge_piece?(row, column, result)
      !corner_piece?(row, column, result) &&
      !center_piece?(row, column, result)
    end

    def corner_piece?(row, column, result)
      (row == 0 || row == result[0].count - 1) &&
      (column == 0 || column == result[0].count - 1)
    end

    def center_piece?(row, column, result)
      (1...result[0].count-1).cover?(row) &&
      (1...result[0].count-1).cover?(column)
    end

    def add_filter(&blk)
      @filters << blk
    end
  end

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
