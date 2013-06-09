require_relative "algorithm"

module CubeSeer 
  class AlgExpander
    attr_reader :algorithm
    def expand(alg)
      @algorithm = Algorithm.new(alg)
      algorithm.collect_concat { |move| expand_move(move) }
    end

    private

    def expand_move(move)
      result = expand_turn(move)
      result = result.collect_concat do |new_move|
        if slice? new_move
          expand_slice(new_move)
        else
          new_move
        end
      end
      result
    end

    def slice?(char)
      %w(M E S).include? char
    end

    def expand_slice(slice)
      {
        "M" => expand("R L' x'"),
        "E" => expand("U D' y'"),
        "S" => expand("B F' z")
      }[slice]
    end

    def expand_turn(move)
      [move[:face]] * move[:magnitude]
    end

  end
end
