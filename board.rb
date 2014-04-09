#!/usr/bin/env ruby

require 'colorize'
require 'debugger'
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

  def display
    @game_space.each_with_index do |row, i|
      row.each_with_index do |piece, j|

        color = (i + j).even? ? :magenta : :cyan
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
    # debugger
    game_space.flatten.each do |piece|
      next if piece.nil?
      next if king_object.color == piece.color
      return true if piece.moves(piece.move_dirs, piece.pos).any? { |move| king_object.pos == move }
    end

    false
  end

  def empty_board!
    @game_space = Array.new(8) { Array.new(8) { nil } }
  end

  def board_dup
    new_board = Board.new
    new_board.empty_board!

    @game_space.flatten.each do |piece|
      next if piece.nil?

      c = piece.color
      p = piece.pos.dup
      b = piece.board

      new_piece = 0

      new_piece = piece.class.new(c, p, b)
      new_board.game_space[new_piece.pos[0]][new_piece.pos[1]] = new_piece
      new_piece.board = new_board
    end

    new_board
  end

  def move(start_pos, end_pos)

    new_board = self.board_dup
    x1, y1 = start_pos
    x2, y2 = end_pos

    player_color = new_board.game_space[x1][y1].color
    p player_color
    #p new_board.game_space[4][4].class
    #+p new_board.game_space[5][5].class
    new_board.game_space[x2][y2] = new_board.game_space[x1][y1]
    new_board.game_space[x1][y1] = nil



    king = new_board.game_space.flatten.select { |piece|
      piece.class == King && piece.color == player_color }.first


    new_board.game_space[x2][y2].pos = [x2, y2]
    # p king

    p king.pos

    if in_check?(king, new_board.game_space)
      raise 'This should put the players king in check'
    end

    self.game_space[x2][y2] = self.game_space[x1][y1]
    self.game_space[x1][y1] = nil
  end
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.empty_board!
  # bish = Bishop.new(:black, [4, 4], b)
  # b.game_space[4][4] = bish
  # p bish.moves(bish.move_dirs, bish.pos)
  #puts "Rook"
  rook = Rook.new(:white, [5, 5], b)
  b.game_space[5][5] = rook
  # p rook.moves(rook.move_dirs, rook.pos)
  #puts "KING"
  rook = Rook.new(:black, [5, 6], b)
  b.game_space[5][6] = rook

  king = King.new(:black, [5, 7], b)
  b.game_space[5][7] = king
  # p king.moves(king.move_dirs, king.pos)
  # puts "Knight"
  # knight = Knight.new(:black, [5, 5], b)
 #  b.game_space[5][5] = knight
 #  #p knight.moves(knight.move_dirs, knight.pos)
 #  puts "Pawn"
 #  piece = Pawn.new(:white, [1, 4], b)
 #  b.game_space[1][4] = piece
 #  p piece.moves(piece.move_dirs, piece.pos)
 # b.display
  # b.game_space[6][4] = Rook.new(:white, [6,4], b)
  # p b.in_check?(b.game_space[7][4])

  c = b.board_dup
  # p b.game_space[4][4].class
  # p b.game_space[5][5].class
  # p c.game_space[4][4].class
  # p c.game_space[5][5].class
  b.move([5,6],[1,6])



end
