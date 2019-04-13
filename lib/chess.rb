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
    piece = Piece.new(1,'queen')
    register_piece_change('add',piece,[3,4])
    run
    #debug
    MAKE NEW PIECE IN VARIOUS SPOTS TO TEST GETMOVES

  end

  def debug
    start_game
    @board.draw_board
    while true
      puts "Select?"
      pos = alpha_to_coords(gets.chomp.upcase)
      @board.squares[pos].select_tog
      get_moves(@board.squares[pos],pos).each do |move|
        @board.squares[pos].select_tog
      end
      @board.draw_board
    end
  end



  def run
    start_game
    @board.draw_board
    while true
      puts "NAIVE"
      puts "Select?"
      pos = alpha_to_coords(gets.chomp.upcase)
      @board.squares[pos].select_tog
      get_moves(@board.squares[pos].piece,pos).each do |move|
        print move
        print "\n"
        @board.squares[move].select_tog
      end

      @board.draw_board
    end
  end

  def alpha_to_coords(alpha)
    arr = alpha.split("")
    x = arr[0].ord-"A".ord
    #minus one because shown coords go from 1-8
    y = arr[1].to_i-1
    return [x,y]
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

  def get_moves(piece,pos)
    moves = []
    piece.get_dirs.each { |dir|
      next_pos = advance(pos,dir)
      if on_board(next_pos) && no_teammate(next_pos,piece)
        if piece.move_type == "dynamic"
          moves.concat(get_moves_in_line(piece,pos,dir))
        elsif piece.move_type == "static"
          moves.push(next_pos)
        end
      end
    }
    return moves
  end

  def advance(pos,dir)
    return [pos[0]+dir[0],pos[1]+dir[1]]
  end

  def on_board(pos)
    return @board.squares.include?(pos)
  end

  def no_teammate(pos,piece)
    raise "this piece ain't on the board bruh" until on_board(pos)
    player = piece.player
    sqr_to_check = @board.squares[pos]
    if sqr_to_check.full
      return sqr_to_check.piece.player != player
    else
      return true
    end
  end

  def get_moves_in_line(piece,pos,dir)
    #gets the number of matches in a given direction
    matches = []
    next_pos = advance(pos,dir)
    collision = false
    while on_board(next_pos) && no_teammate(next_pos,piece) && !collision
      collision = @board.squares[next_pos].full
      matches.push(next_pos)
      next_pos = advance(next_pos,dir)
    end
    return matches
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
