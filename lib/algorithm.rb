module CubeSeer
  class Algorithm
    include Enumerable
    attr_reader :moves
    def initialize(alg)
      @alg_string = alg
      @moves = split_alg(alg)
    end

    def each(&block)
      moves.each(&block)
    end

    private

    def split_alg(alg)
      alg = alg.gsub(/\s+/, "")
      moves = alg.each_char.slice_before { |char| turn_starter? char }.map(&:join)
      moves.map { |move| to_hash(move) }
    end

    def to_hash(move)
      {
        face: face(move),
        magnitude: magnitude(move)
      }
    end

    def face(move)
      move.each_char.take_while { |char| !modifier? char }.join
    end

    def modifier?(char)
      char == "'" || char == "2"
    end

    def magnitude(move)
      if double_move? move      
        2
      elsif prime_move? move
        3
      else
        1
      end
    end

    def double_move?(move)
      move.end_with?("2", "2'")
    end

    def prime_move?(move)
      move.end_with?("'")
    end

    def turn_starter?(char)
      %w(U D L R F B M E S x y z).include? char
    end
  end
end
