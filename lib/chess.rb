require "./lib/board"
require "./lib/square"
require "./lib/unicode"


board = Board.new
pos = [2,5]
square = board.squares[pos]
puts square.to_s
