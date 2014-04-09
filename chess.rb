#!/usr/bin/env ruby

require './board.rb'
require './pieces.rb'
require './humanplayer.rb'
require 'colorize'

class Game
  attr_accessor :board

  def initialize
    @board = Board.new
    @w_player = HumanPlayer.new(:white)
    @b_player = HumanPlayer.new(:black)
  end

  def play
    system "clear"
    puts "\nWelcome to Chess - Enterprise Edition\u2122!! (with raving)".colorize(:magenta)
    puts "Press enter to rave on!!\n".colorize(:cyan)
    @board.display
    print "\n\n"
    gets
    player = @b_player
    loop do
      player = @w_player == player ? @b_player : @w_player

      break if over?(player.color)

      system "clear"
      print "\nChess - Enterprise Edition\u2122".colorize(:magenta)
      print "\nBrought to you by mdevolld and pingram\n\n".colorize(:cyan)

      @board.display

      begin
        puts "\n\nIt is #{player.color}'s turn.".colorize(:magenta)
        if @board.in_check?(player.color, @board.game_space)
          puts "You are in Check.".colorize(:red)
        end
        new_move = player.get_move
        piece = @board.move(new_move, player.color)
        if piece.promoted?
          new_piece_desired = player.promote
          @board.promote_piece(piece, new_piece_desired)
        end
      rescue ArgumentError => e
        print "\n"
        puts e.to_s.red.on_black.blink
        retry
      end
    end

    @board.display

    if @board.checkmate?(player.color)
      puts "Checkmate! #{player.color} lost. Let's go dance.".colorize(:magenta)
    else
      puts "Stalemate! Let's go dance.".colorize(:magenta)
    end


  end

  def over?(color)
    @board.checkmate?(color) || @board.stalemate?(color)
  end
end

if __FILE__ == $PROGRAM_NAME
  a = Game.new
  a.board.empty_board!
  a.board.place_piece(a.board, King.new(:white, [5,5], a.board))
  a.board.place_piece(a.board, King.new(:black, [4,3], a.board))
  a.board.place_piece(a.board, Pawn.new(:white, [6,6], a.board))
  a.play





end