require "./lib/board"
require "./lib/square"
require "./lib/unicode"
require "./lib/player"
require "./lib/piece"

class Chess
  def initialize
    @board = Board.new
    @players = {1=>Player.new(1), 2=>Player.new(2)}
    @players.each do |name,player| place_pieces(name) end
    run

  end

  def run
    start_game
    while false
      puts "NAIVE"
      puts "Select?"
      #pos = alpha_to_coords(gets.chomp.upcase)

      @board.draw_board
    end
    @board.draw_board
  end

  def alpha_to_coords(alpha)
    arr = alpha.split("")
    x = arr[0].ord
    return
  end

  def start_game
    draw_start
  end

  def draw_start
    puts "Nice, the game started"
  end

  def register_piece_change(change, piece, pos)
    if change == "add"
      #add to squares hash
      @board.squares[pos].add(piece)
      #add to pieces hash in players
      @players[piece.player].add_piece(pos,piece)
    end
  end


  def place_pieces(player)
    raise "name needs to be 1 or 2" until (1..2).include?(player)
    player == 1 ? (start, dir = [0,0], 1) : (start, dir = [7,7], -1)
    row1 = ['rook','knight','bishop','queen','king','bishop','knight','rook']
    row2 = Array.new(8,'pawn')
    type_rows = [row1,row2]
    y = start[1]
    type_rows.each {|row|
      x = start[0]
      row.each {|type|
        pos = [x,y]
        piece = Piece.new(player,type)
        register_piece_change("add", piece, pos)
        x += dir
      }
      y += dir
    }
  end
end

Chess.new
