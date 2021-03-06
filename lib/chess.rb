require "./lib/board"
require "./lib/square"
require "./lib/unicode"
require "./lib/player"
require "./lib/piece"
require 'yaml'

class Chess
  def initialize
    @board = Board.new
    @players = {1=>Player.new(1), 2=>Player.new(2)}
    @players.each do |name,player| place_pieces(name) end
    @checkmate = false
    run
    #debug

  end



  def run
    start_game
    @board.draw_board
    @status = "unselected"
    plr = 1
    while !@checkmate
      puts plr
      if @status == 'unselected'
        player = @players[plr]
        check_check(player)
        puts "Player #{plr}'s turn"
        puts "Choose piece to move, 'save' to save game"
        if !@checkmate
          pos = get_input(player.pieces)
          toggle_moves(pos) if !@checkmate
        end
        @status = 'selected'
      elsif @status == 'selected'
        puts "Choose a move"
        move = get_input(get_moves(@board.squares[pos].piece,pos))
        move_piece(player,pos,move)
        plr = plr == 1 ? 2 : 1
        @status = 'unselected'
      end
      @board.draw_board
    end
  end

  def check_check(player)
    #player is the one whose turn it's about to be (in run)
    mate = false
    other_player = player.name == 1 ? @players[2] : @players[1]
    king = Hash.new
    player.pieces.each { |pos,piece| king[pos] = piece if piece.type == 'king' }
    pos = king.keys[0]
    op_moves = player_moves(other_player)
    if op_moves.include?(pos)
      puts "Player #{player.name} is in CHECK"
      #check_checkmate
      mate = get_moves(king[pos],pos).all? { |pos| op_moves.include?(pos) }
      if mate
        puts "CHECKMATE"
        @checkmate = true
      end

    end
    #get_moves(king[pos],pos)
    return mate
  end

  def check_checkmate
    #i'll do something when I'm good and ready
  end

  def player_moves(player)
    moves = []
    player.pieces.each { |pos,piece|
      moves.concat(get_moves(piece,pos))
    }
    return moves
  end



  def move_piece(player,pos,move)
    #moves a players piece at a position to a new one
    toggle_moves(pos)
    piece = @board.squares[pos].piece
    move_sqr = @board.squares[move]
    #makes pawns move one space only
    piece.moved = true if piece.type == 'pawn' && !piece.moved
    if move_sqr.full
      #removes the current piece in the move square
      register_piece_change('remove', move_sqr.piece, move)
    end
    register_piece_change('add', piece, move)
    register_piece_change('remove',piece, pos)
  end


  def toggle_moves(pos)
    #highlights the current position and all possible moves
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
        pos = alpha_to_coords(raw)
        case @status
        when 'unselected'
          piece = @board.squares[pos].piece
          if get_moves(piece,pos).length > 0
            valid = true
          else
            puts "invalid"
          end
        when 'selected'
          valid = true
        end
      elsif raw == 'SAVE'
        save_game
        valid =true
      else
        puts "invalid"
      end
    end
    return alpha_to_coords(raw)
  end



  def alpha_to_coords(alpha)
    #turns a coor of the form char,num into the correpsonding x,y
    arr = alpha.split("")
    x = arr[0].ord-"A".ord
    #minus one because shown coords go from 1-8
    y = arr[1].to_i-1
    return [x,y]
  end

  def start_game
    draw_start
    valid = false
    until valid
      raw = gets.chomp
      if raw == 'l'
        load_game
        valid = true
      elsif raw == 'n'
        valid = true
      else
        puts "c'mon, ya got two options fam"
      end
    end
  end

  def load_game
    data = YAML.load(File.open('save.yaml','r').read)
    @board.load_board(data[:board])
    @players[1].load_pieces(data[:player_1_pieces])
    @players[2].load_pieces(data[:player_2_pieces])
  end

  def save_game
    #saves variables as a yaml string
    puts "saving..."
    data = YAML.dump ({
      :board => @board.squares,
      :player_1_pieces => @players[1].pieces,
      :player_2_pieces => @players[2].pieces
    })

    file = File.open("save.yaml","w")
    file.puts data
    file.close
    puts "Game saved!"
    @checkmate = true
  end

  def draw_start
    print "\n"*30
    puts "Welcome to Console Chess!"
    puts "l: load saved game, n: start new game"
  end

  def register_piece_change(change, piece, pos)
    #whenever a piece state changes, tells the board and the players
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
    #gets a list of the moves that a piece can make
    #no collision with teammates and must be on board
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
    #gets the position a direction away from a pos
    return [pos[0]+dir[0],pos[1]+dir[1]]
  end

  def on_board(pos)
    return @board.squares.include?(pos)
  end

  def no_teammate(pos,piece)
    #is there not a teammate in this position
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
    #initilaization function, puts the pieces in the starting squares
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
