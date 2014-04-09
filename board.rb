class Board
  attr_accessor :game_space

  def initialize
    @game_space = Array.new(8) { Array.new(8) { nil } }
    initial_piece_placement
  end

  def display
    @game_space.reverse.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        color = (i + j).even? ? :yellow : :cyan
        if piece.nil?
          print '  '.colorize(:background => color)
        else
          print "#{piece.display_char.colorize(piece.color)} ".colorize(:background => color)
        end
      end

      puts "\n"
    end

    nil
  end

  def in_check?(king_object, game_space)
    game_space.flatten.compact.each do |piece|
      next if king_object.color == piece.color
      return true if piece.moves(piece.move_dirs, piece.pos).any? do |move|
        king_object.pos == move
      end
    end

    false
  end

  def empty_board!
    @game_space = Array.new(8) { Array.new(8) { nil } }
  end

  def board_dup
    new_board = Board.new
    new_board.empty_board!

    @game_space.flatten.compact.each do |piece|
      c, p, b = piece.color, piece.pos.dup, piece.board
      place_piece(new_board, piece.class.new(c, p, b))
    end

    new_board
  end

  def valid_moves(player_color)
    valid_moves = []

    @game_space.flatten.each do |piece|
      next if piece.nil? || piece.color != player_color
      piece.moves(piece.move_dirs, piece.pos).each do |piece_move|

        new_board = self.board_dup
        x1, y1 = piece.pos
        x2, y2 = piece_move

        new_board.game_space[x2][y2] = new_board.game_space[x1][y1]
        new_board.game_space[x1][y1] = nil

        king = new_board.game_space.flatten.select do |piece|
          piece.class == King && piece.color == player_color
        end.first

        new_board.game_space[x2][y2].pos = [x2, y2]

        unless in_check?(king, new_board.game_space)
          valid_moves << [piece.pos, piece_move]
        end
      end
    end

    valid_moves
  end

  def checkmate?(player_color)
    king = @game_space.flatten.select { |piece|
      piece.class == King && piece.color == player_color }.first

    valid_moves(player_color).empty? && in_check?(king, @game_space)
  end

  def stalemate?(player_color)
    king = @game_space.flatten.select { |piece|
      piece.class == King && piece.color == player_color }.first

    valid_moves(player_color).empty? && !in_check?(king, @game_space)
  end

  def move(move_arr, player_color)
    if valid_moves(player_color).include?(move_arr)
      x1, y1 = move_arr[0]
      x2, y2 = move_arr[1]

      self.game_space[x2][y2] = self.game_space[x1][y1]
      self.game_space[x1][y1] = nil

      self.game_space[x2][y2].pos = [x2, y2]

    else
      raise ArgumentError.new('Invalid move')
    end
  end

  # Regardless of what's there put the piece on the board overwriting the current piece
  def place_piece(board, piece)
    board.game_space[piece.pos[0]][piece.pos[1]] = piece
  end

  #assume move is valid / already checked
  def move_piece(board, piece, new_pos)
    board.game_space[piece.pos[0]][piece.pos[1]] = nil
    piece.pos = new_pos
    board.game_space[piece.pos[0]][piece.pos[1]] = piece
  end

  private
  def initial_piece_placement
    (0..7).each do |col|
      #white pawn
      @game_space[1][col] = Pawn.new(:white, [1, col], self)
      #black pawn
      @game_space[6][col] = Pawn.new(:black, [6, col], self)
    end

    pieces = { :knight => [[0, 1], [0, 6], [7, 1], [7, 6]],
                      :rook => [[0, 0],[0, 7], [7, 0],[7, 7]],
                      :bishop => [[0, 2], [0, 5], [7, 2], [7, 5]],
                      :queen => [[0, 3], [7, 3]],
                      :king => [[0, 4], [7, 4]]
                    }
    pieces.each do |piece_type, piece_poses|
      piece_poses.each do |piece_pos|
        color = piece_pos[0] == 0 ? :white : :black
        case piece_type
        when :knight
          @game_space[piece_pos[0]][piece_pos[1]] = Knight.new(color, piece_pos, self)
        when :rook
          @game_space[piece_pos[0]][piece_pos[1]] = Rook.new(color, piece_pos, self)
        when :bishop
          @game_space[piece_pos[0]][piece_pos[1]] = Bishop.new(color, piece_pos, self)
        when :queen
          @game_space[piece_pos[0]][piece_pos[1]] = Queen.new(color, piece_pos, self)
        when :king
          @game_space[piece_pos[0]][piece_pos[1]] = King.new(color, piece_pos, self)
        end
      end
    end
  end
end
