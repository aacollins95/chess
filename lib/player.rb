class Player
  attr_reader :piece
  def initialize(name)
    @name = name
    puts "Hi, I'm player #{@name}!"
    @piece = Piece.new(name,"king")
  end
end
