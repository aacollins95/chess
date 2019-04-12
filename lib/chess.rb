require "./lib/board"
require "./lib/square"
require "./lib/unicode"
require "./lib/player"

class Chess
  def initialize
    @board = Board.new
    @players = {1=>Player.new(1), 2=>Player.new(2)}
  end
end

Chess.new
