require "minitest/autorun"

class ColorScheme
  def [](face)
    "white"
  end
end

class ColorSchemeTest < Minitest::Test
  def test_returns_colors
    color_scheme = ColorScheme.new
    assert_equal color_scheme[:U],
                 "white"
  end
end
