require "minitest/autorun"

require_relative "../lib/alg_expander"

class AlgExpanderTest < Minitest::Test
  def setup
    @expander = AlgExpander.new
  end

  def test_keep_single_moves_same
    assert_equal ["R"], @expander.expand("R")
  end

  def test_handles_wide_turns
    assert_equal ["Rw"], @expander.expand("Rw")
  end

  def test_handles_wide_turns_with_modifiers
    assert_equal ["Rw", "Rw"], @expander.expand("Rw2")
  end

  def test_expands_slices
    assert_equal ["Lw", "L", "L", "L", "Lw", "L", "L", "L"], @expander.expand("M2")
  end

  def test_converts_slices_to_wides
    assert_equal ["Lw", "L", "L", "L"], @expander.expand("M")
  end

  def test_expand_double_moves_to_two_single
    assert_equal ["R", "R"], @expander.expand("R2")
  end

  def test_expand_prime_moves_to_three_single
    assert_equal ["R", "R", "R"], @expander.expand("R'")
  end

  def test_expand_multiple_moves
    assert_equal ["R", "U", "U"], @expander.expand("R U2")
  end

  def test_ignore_whitespace
    assert_equal ["R", "U", "U"], @expander.expand("RU2")
  end

end
