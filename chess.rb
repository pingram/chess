class Piece
  DIAGONALS = [[1, 1], [-1, 1], [-1, -1], [-1, -1]]
  FILES = [[1, 0], [-1, 0], [0, -1], [0, 1]]
  def initialize(color, pos)
    @color = color
    @pos = pos
  end

  def moves
    raise 'NOT IMPLEMENTED'
  end

  def board_space_empty?(pos)

  end

end

class SlidingPieces < Piece
  def moves(move_dir)

  end

end

class SteppingPieces < Piece
end

class Bishop < SlidingPieces
  def initialize(color, pos)
    @move_dir = DIAGONALS
    super(color, pos)
  end
  def moves(move_dir)
    super(@move_dir)
  end
end

class Rook < SlidingPieces
  def initialize(color, pos)
    @move_dir = FILES
    super(color, pos)
  end
  def moves(move_dir)
    super(@move_dir)
  end
end

class Queen < SlidingPieces
  def initialize(color, pos)
    @move_dir = DIAGONALS + FILES
    super(color, pos)
  end
  def moves(move_dir)
    super(@move_dir)
  end
end

class Knight < SteppingPieces
end

class King < SteppingPieces
end

class Pawn < Piece
end

class Board
  attr_accessor :game_space

  def initialize
    @game_space = Array.new(8) { Array.new(8) { nil } }
  end
end


