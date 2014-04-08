#!/usr/bin/env ruby

class Piece
  attr_accessor :move_dirs, :pos, :color
  DIAGONALS = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
  FILES = [[1, 0], [-1, 0], [0, -1], [0, 1]]
  KING_MOVES = DIAGONALS + FILES
  KNIGHT_MOVES = [[-1, 2], [-1, -2], [1, 2], [1, -2], [-2, -1], [-2, 1],
                  [2, -1], [2, 1]]

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

    valid_moves.uniq
  end
end

class SteppingPieces < Piece
  def moves(move_dirs, pos)
    valid_moves = []

    move_dirs.each do |delta|
      new_x = pos[0] + delta[0]
      new_y = pos[1] + delta[1]

      next unless (new_x.between?(0, 7) && new_y.between?(0, 7))

      if board_space_empty?([new_x, new_y]) || opponent_piece?([new_x, new_y])
        valid_moves += [[new_x, new_y]]
      end
      #
      # if opponent_piece?([new_x, new_y])
      #   valid_moves += [[new_x, new_y]]
      # end
    end

    valid_moves.uniq
  end
end

class Bishop < SlidingPieces
  def initialize(color, pos, board)
    @move_dirs = DIAGONALS
    super(color, pos, board)
  end
end

class Rook < SlidingPieces
  def initialize(color, pos, board)
    @move_dirs = FILES
    super(color, pos, board)
  end
end

class Queen < SlidingPieces
  def initialize(color, pos, board)
    @move_dirs = DIAGONALS + FILES
    super(color, pos, board)
  end
end

class Knight < SteppingPieces
  def initialize(color, pos, board)
    @move_dirs = KNIGHT_MOVES
    super(color, pos, board)
  end
end

class King < SteppingPieces
  def initialize(color, pos, board)
    @move_dirs = KING_MOVES
    super(color, pos, board)
  end
end

class Pawn < Piece
  def initialize(color, pos, board)
    super(color, pos, board)
    @move_dirs = nil
  end

  def moves(move_dirs, pos)
    x, y = self.pos
    valid_moves = []
    if @color == :black
      delta = - 1
    else
      delta = 1
    end

    new_x = x + delta

    return [] unless ((new_x).between?(0, 7) && y.between?(0, 7))

    valid_moves << [new_x, y]

    unless has_moved?
      valid_moves << [x + (delta * 2), y]
    end


    if (y + 1).between?(0,7) && opponent_piece?([new_x, y + 1])
      valid_moves << [new_x, y + 1]
    end
    if (y - 1).between?(0,7) && opponent_piece?([new_x, y - 1])
      valid_moves << [new_x, y - 1]
    end

    valid_moves
  end

  def has_moved?
    if @color == :black && @pos[0] == 6
      return false
    elsif @color == :white && @pos[0] == 1
      return false
    end

    true
  end

end

class Board
  attr_accessor :game_space

  def initialize
    @game_space = Array.new(8) { Array.new(8) { nil } }
  end
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  # bish = Bishop.new(:black, [4, 4], b)
  # b.game_space[4][4] = bish
  # p bish.moves(bish.move_dirs, bish.pos)
  # puts "Rook"
  # rook = Rook.new(:black, [4, 4], b)
  # b.game_space[4][4] = rook
  # p rook.moves(rook.move_dirs, rook.pos)
  # puts "KING"
  # king = King.new(:black, [4, 4], b)
  # b.game_space[4][4] = king
  # p king.moves(king.move_dirs, king.pos)
  # puts "Knight"
  # knight = Knight.new(:black, [5, 5], b)
 #  b.game_space[5][5] = knight
 #  #p knight.moves(knight.move_dirs, knight.pos)
 #  puts "Pawn"
 #  piece = Pawn.new(:white, [1, 4], b)
 #  b.game_space[1][4] = piece
 #  p piece.moves(piece.move_dirs, piece.pos)


end

#b = Bishop.new(:black, [0,0], Board.new)
#b.moves