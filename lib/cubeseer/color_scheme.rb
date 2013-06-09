module CubeSeer
  class ColorScheme
    attr_reader :options
    def initialize(overrides = {})
      @options = defaults.merge(overrides)
    end

    class << self
      def from_string(cols)
        raise "color scheme must have 6 colors, received #{cols}" unless cols.length == 6
        overrides = cols.each_char.zip(FACES).each_with_object({}) do |(letter, face), hsh|
        hsh[face] = letter_to_color(letter)
        end
        new(overrides)
      end

      FACES = %w(U R F D L B).map(&:to_sym)

      COLOURS = {
        "w" => :white,
        "r" => :red,
        "g" => :green,
        "o" => :orange,
        "y" => :yellow,
        "b" => :blue,
        "x" => :gray
      }

      def letter_to_color(letter)
        COLOURS[letter]
      end
    end

    def [](face)
      options[face]
    end

    def defaults
      {
        U: :white,
        F: :green,
        R: :red,
        L: :orange,
        D: :yellow,
        B: :blue
      }
    end
  end
end
