class Player
  attr_reader :piece, :pieces, :name
  def initialize(name)
    @name = name
    #puts "Hi, I'm player #{@name}!"
    @pieces = Hash.new
  end

  def add_piece(pos,piece)
    @pieces[pos] = piece
  end

  def del_piece(pos, piece)
    @pieces.delete(pos)
  end

  def load_pieces(pcs)
    @pieces = pcs
  end
end
