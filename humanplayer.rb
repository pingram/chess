class HumanPlayer
  attr_reader :color
  def initialize(color)
    @color = color
  end

  def get_move
    puts "Please enter your move:".colorize(:magenta)
    user_input = gets.chomp.downcase

    if user_input.length != 5
      raise ArgumentError.new('Must be in format "e2 e4"'.colorize(:magenta))
    end

    # TODO more validating user input
    move = user_input.split(' ')

    # reversing user input becuase of how 2d arrays work
    from = move[0].reverse
    to = move[1].reverse

    player_map = { 'a' => 0,
                   'b' => 1,
                   'c' => 2,
                   'd' => 3,
                   'e' => 4,
                   'f' => 5,
                   'g' => 6,
                   'h' => 7 }

    from_x, from_y = from.split('')
    to_x, to_y = to.split('')

    new_from = [from_x.to_i - 1, player_map[from_y]]
    new_to = [to_x.to_i - 1, player_map[to_y]]
    # p [new_from, new_to]

    [new_from, new_to]
  end
end