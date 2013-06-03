class AlgExpander
  def expand(alg)
    moves = split_alg(alg)
    moves.collect_concat { |move| expand_move(move) }
  end

  private

  def split_alg(alg)
    alg = alg.gsub(/\s+/, "")
    alg.each_char.slice_before { |char| turn_starter? char }.map(&:join)
  end

  def turn_starter?(char)
    %w(U D L R F B M E S x y z).include? char
  end

  def slice?(char)
    %w(M E S).include? char
  end

  def expand_move(move)
    result = expand_turn(move)
    result = result.collect_concat do |new_move|
      if slice? new_move
        expand_slice(new_move).collect_concat {|turn| expand_turn(turn)}
      else
        new_move
      end
    end
    result
  end

  def expand_slice(slice)
    {
      "M" => ["R", "L'", "x'"],
      "E" => ["U", "D'", "y'"],
      "S" => ["B", "F'", "z"]
    }[slice]
  end

  def expand_turn(move)
    [face(move)] * 
    if double_move? move      
      2
    elsif prime_move? move
      3
    else
      1
    end
  end

  def face(move)
    move.each_char.take_while { |char| !modifier? char }.join
  end

  def modifier?(char)
    char == "'" || char == "2"
  end

  def prime_move?(move)
    move.end_with?("'")
  end

  def double_move?(move)
    move.end_with?("2", "2'")
  end

end
