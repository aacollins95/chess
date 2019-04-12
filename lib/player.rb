class Player
  attr_reader :piece
  def initialize(name)
    @name = name
    puts "Hi, I'm player #{@name}!"
    @pieces = Hash.new
  end

  def add_piece(piece)
    
  end

end
