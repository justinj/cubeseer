require_relative "test_helper"


module CubeSeer
  class FilterTest < Minitest::Test
    def setup
      @cube = Minitest::Mock.new
      @filter = CubeFilter.new(@cube, {})
    end

    def filter(opts)
      @filter = CubeFilter.new(@cube, opts)
    end

    def set_query_response(response)
      @cube.expect :query, response, [String]
    end

    def test_asks_cube
      filter({})
      @cube.expect :query, nil, [String]
      @filter["UBL:UFR"]
      @cube.verify
    end

    def test_filters_nothing_by_default
      filter({})
      set_query_response [[:U, :U, :U]]
      assert_equal [[:U, :U, :U]], @filter["UBL:URB"]
    end

    def test_except_filters_edges_row
      filter(:except => :edges)
      set_query_response [[:U, :U, :U]]
      assert_equal [[:U, :X, :U]], @filter["UBL:URB"]
    end

    def test_filters_edges_row
      filter(:only => :edges)
      set_query_response [[:U, :U, :U]]
      assert_equal [[:X, :U, :X]], @filter["UBL:URB"]
    end

    def test_filters_corners_row
      filter(:only => :corners)
      set_query_response [[:U, :U, :U]]
      assert_equal [[:U, :X, :U]], @filter["UBL:URB"]
    end

    def test_filters_centers_row
      filter(:only => :centers)
      set_query_response [[:U, :U, :U]]
      assert_equal [[:X, :X, :X]], @filter["UBL:URB"]
    end

    def test_filters_edges_face
      filter(:only => :edges)
      set_query_response [[:U, :U, :U],
        [:U, :U, :U],
        [:U, :U, :U]]
      assert_equal [[:X, :U, :X],
        [:U, :X, :U],
        [:X, :U, :X]], @filter["UBL:UFR"]
    end

    def test_except_filters_centers_face
      filter(:except => :centers)
      set_query_response [[:U, :U, :U],
                          [:U, :U, :U],
                          [:U, :U, :U]]
      assert_equal [[:U, :U, :U],
                    [:U, :X, :U],
                    [:U, :U, :U]], @filter["UBL:UFR"]
    end

    def test_filters_centers_face
      filter(:only => :centers)
      set_query_response [[:U, :U, :U],
                          [:U, :U, :U],
                          [:U, :U, :U]]
      assert_equal [[:X, :X, :X],
                    [:X, :U, :X],
                    [:X, :X, :X]], @filter["UBL:UFR"]
    end
  end
end
