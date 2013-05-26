class AlgExpander
  def expand(alg)
    moves = split_alg(alg)
    moves.collect_concat { |move| expand_move(move) }
  end

  private

  def split_alg(alg)
    alg = alg.gsub(/\s+/, "")
    alg.each_char.slice_before { |char| face? char }.map(&:join)
  end

  def face?(char)
    %w(U D L R F B).include? char
  end

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
