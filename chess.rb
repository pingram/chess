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
    print "\n"
    gets
    player = @b_player
    loop do
      player = @w_player == player ? @b_player : @w_player

      break if over?(player.color)

      system "clear"
      print "\nChess - Enterprise Edition\u2122".colorize(:cyan)
      print "\nBrought to you by mdevolld and pingram\n\n".colorize(:cyan)

      @board.display

      begin
        puts "\nIt is #{player.color}'s turn: ".colorize(:magenta)
        new_move = player.get_move
        @board.move(new_move, player.color)
      rescue ArgumentError => e
        print "\n"
        puts e.to_s.colorize(:red)
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
  Game.new.play
end