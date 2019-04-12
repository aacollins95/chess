require "./lib/board"
require "./lib/square"
require "./lib/unicode"
require "./lib/player"
require "./lib/piece"

class Chess
  def initialize
    @board = Board.new
    @players = {1=>Player.new(1), 2=>Player.new(2)}
    pos = [3,3]
    @board.squares[pos].add(@players[1].piece)
    @board.draw_board
  end
end

Chess.new
