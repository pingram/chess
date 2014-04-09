require './board.rb'
require './pieces.rb'
require './humanplayer.rb'

class Game
  attr_accessor :board

  def initialize
    @board = Board.new
    @w_player = HumanPlayer.new(:white)
    @b_player = HumanPlayer.new(:black)
  end

  def play
    puts "\n\nWelcome to Chess - Enterprise Edition!! (with raving)"
    player = @b_player
    loop do
      player = @w_player == player ? @b_player : @w_player

      p @board.valid_moves(player.color)

      break if over?(player.color)

      p player.color
      @board.display

      begin
        new_move = player.get_move
        @board.move(new_move, player.color)
      rescue ArgumentError => e
        puts e
        retry
      rescue InvalidMoveError => e
        puts e
        retry
      end
    end

    @board.display

    if @board.checkmate?(player.color)
      puts "Checkmate! #{player.color} lost. Let's go dance."
    else
      puts "Stalemate! Let's go dance."
    end


  end

  def over?(color)
    @board.checkmate?(color) || @board.stalemate?(color)
  end


end


# g = Game.new
# g.board.empty_board!
# g.board.place_piece(King.new(:black, [0,0], g.board))
# g.board.place_piece(King.new(:white, [4,4], g.board))
# g.board.place_piece(Queen.new(:white, [1,2], g.board))
# g.play













