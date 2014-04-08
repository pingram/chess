#!/usr/bin/env ruby

require './pieces.rb'

class Board
  attr_accessor :game_space

  def initialize
    @game_space = Array.new(8) { Array.new(8) { nil } }

    # WHILTE PIECES

    (0..7).each do |col|
      #white pawn
      @game_space[1][col] = Pawn.new(:white, [1, col], self)
      #black pawn
      @game_space[6][col] = Pawn.new(:black, [6, col], self)
    end

    pieces = { :knight => [[0, 1], [0, 6], [7, 1], [7, 6]],
                      :rook => [[0, 0],[0, 7], [7, 0],[7, 7]],
                      :bishop => [[0, 2], [0, 5], [7, 2], [7, 5]],
                      :queen => [[0, 4], [7, 4]],
                      :king => [[0, 3], [7, 3]]
                    }
    pieces.each do |piece_type, piece_poses|
      piece_poses.each do |piece_pos|
        color = piece_pos == 1 ? :white : :black
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

  def display
    @game_space.each do |row|
      row.each do |piece|
        if piece.nil?
          print '  '
        else
          print piece.display_char + ' '

        end
      end

      puts "\n"
    end

    nil
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
 b.display
end
