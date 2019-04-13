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

  end



  def run
    start_game
    @board.draw_board
    status = "unselected"
    player = @players[1]
    while true
      if status == 'unselected'
        puts "Choose piece to move"
        pos = get_input(player.pieces)
        toggle_moves(pos)
        status = 'selected'
      elsif status == 'selected'
        puts "Choose a move"
        move = get_input(get_moves(@board.squares[pos].piece,pos))
        move_piece(player,pos,move)
        status = 'unselected'
      end
      @board.draw_board
    end
  end

  def move_piece(player,pos,move)
    toggle_moves(pos)
    piece = @board.squares[pos].piece
    move_sqr = @board.squares[move]
    if move_sqr.full
      #removes the current piece in the move square
      register_piece_change('remove', move_sqr.piece, move)
    end
    register_piece_change('add', piece, move)
    register_piece_change('remove',piece, pos)
  end


  def toggle_moves(pos)
    @board.squares[pos].select_tog
    get_moves(@board.squares[pos].piece,pos).each do |move|
      @board.squares[move].select_tog
    end
  end

  def get_input(options)
    #make parameter 'options' that contains valid positions
    valid = false
    until valid
      raw = gets.chomp.upcase
      if raw.length == 2 && !raw.match(/[A-H][1-8]/).nil? &&
         options.include?(alpha_to_coords(raw))
        valid = true
      else
        puts "invalid"
      end
    end
    return alpha_to_coords(raw)
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
    elsif change == "remove"
      #add to squares hash
      @board.squares[pos].remove(piece)
      #add to pieces hash in players
      @players[piece.player].del_piece(pos,piece)
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
