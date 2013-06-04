require_relative "../lib/color_scheme"

module CubeSeer
  class ColorSchemeTest < Minitest::Test

    def test_defaults
      color_scheme = ColorScheme.new
      assert_equal :white , color_scheme[:U]
      assert_equal :red   , color_scheme[:R]
      assert_equal :green , color_scheme[:F]
      assert_equal :yellow, color_scheme[:D]
      assert_equal :orange, color_scheme[:L]
      assert_equal :blue  , color_scheme[:B]
    end

    def test_specify
      color_scheme = ColorScheme.new(U: :purple)
      assert_equal :purple , color_scheme[:U]
    end

    def test_from_string
      # Colors are in URFDLB, same as VisualCube
      color_scheme = ColorScheme.from_string("wrgggg")
      assert_equal :white , color_scheme[:U]
      assert_equal :red   , color_scheme[:R]
      assert_equal :green , color_scheme[:F]
      assert_equal :green , color_scheme[:D]
      assert_equal :green , color_scheme[:L]
      assert_equal :green , color_scheme[:B]
    end

    def test_from_string_error
      assert_raises(RuntimeError) { ColorScheme.from_string("www") }
      assert_raises(RuntimeError) { ColorScheme.from_string("wwwwwwwww") }
    end
  end
end
