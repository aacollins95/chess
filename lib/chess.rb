require "./lib/board"
require "./lib/square"
require "./lib/unicode"


(0..2).each { |i|
  print Unicode.box(false,i)
}
puts " "
#board = Board.new
#puts board.squares
