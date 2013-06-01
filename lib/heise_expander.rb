class HeiseExpander
  MAPPINGS = {
    "i" => "R",
    "k" => "R'",
    "j" => "U",
    "f" => "U'",
    "d" => "L",
    "e" => "L'",
    "u" => "r",
    "m" => "r'",
    "v" => "l",
    "r" => "l'",
    "h" => "F",
    "g" => "F'",
    "s" => "D",
    "l" => "D'",
    ";" => "y",
    "a" => "y'",
    "w" => "B",
    "o" => "B'",
    "y" => "x",
    "t" => "x",
    "b" => "x'",
    "n" => "x'",
    "p" => "z",
    "q" => "z'",
    "z" => "Uw"
  }

  def expand(heise)
    heise.each_char.map { |key| key_to_move(key) }.join " "
  end

  def key_to_move(key)
    MAPPINGS[key]
  end
end
