class Piece
  attr_accessor :move_dir, :pos, :color
  DIAGONALS = [[1, 1], [-1, 1], [-1, -1], [-1, -1]]
  FILES = [[1, 0], [-1, 0], [0, -1], [0, 1]]
  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
  end

  def moves
    raise 'NOT IMPLEMENTED'
  end

  def board_space_empty?(pos)
    x, y = pos
    @board.game_space[x][y].nil?
  end

  def opponent_piece?(pos)
    x, y = pos
    return false if @board.game_space[x][y].nil?
    @board.game_space[x][y].color != self.color
  end

end

class SlidingPieces < Piece

  def moves(move_dirs, pos)

    valid_moves = []

    # p pos

    move_dirs.each do |delta|
      new_x = pos[0] + delta[0]
      new_y = pos[1] + delta[1]

      next unless (new_x.between?(0, 7) && new_y.between?(0, 7))

      if board_space_empty?([new_x, new_y])
        valid_moves += [[new_x, new_y]]

        valid_moves += moves([delta], [new_x, new_y])
      end

      if opponent_piece?([new_x, new_y])
        valid_moves += [[new_x, new_y]]
      end
    end

    valid_moves
  end
end

class SteppingPieces < Piece
end

class Bishop < SlidingPieces
  def initialize(color, pos, board)
    @move_dir = DIAGONALS
    super(color, pos, board)
  end

  def moves(move_dir, pos)
    # TDOD CHANGE OTHER CLASSES TO THIS
    super(move_dir, pos)
  end
end

class Rook < SlidingPieces
  def initialize(color, pos, board)
    @move_dir = FILES
    super(color, pos, board)
  end
end

class Queen < SlidingPieces
  def initialize(color, pos, board)
    @move_dir = DIAGONALS + FILES
    super(color, pos, board)
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

#b = Bishop.new(:black, [0,0], Board.new)
#b.moves