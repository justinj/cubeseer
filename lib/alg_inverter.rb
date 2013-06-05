require_relative "algorithm"

module CubeSeer
  class AlgInverter
    def invert(alg)
      algorithm = Algorithm.new(alg)
      algorithm.map { |move| invert_move move }.reverse.join " "
    end

    private

    def invert_move(move)
      hash_to_move(:face => move[:face], :magnitude => 4 - move[:magnitude])
    end

    def hash_to_move(move_hash)
      face = move_hash[:face]
      mag = move_hash[:magnitude]
      face + magnitude_to_modifier(mag)
    end

    def magnitude_to_modifier(magnitude)
      case magnitude
      when 1
        ""
      when 2
        "2"
      when 3
        "'"
      end
    end

  end

end
