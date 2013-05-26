class AlgExpander
  def expand(alg)
    moves = alg.split(/\s+/)
    moves.collect_concat { |move| expand_move(move) }
  end

  private

  def expand_move(move)
    [face(move)] * 
    if prime_move? move
      3
    elsif double_move? move
      2
    else
      1
    end
  end

  def face(move)
    move[0]
  end

  def prime_move?(move)
    move.end_with?("'")
  end

  def double_move?(move)
    move.end_with?("2")
  end

end
