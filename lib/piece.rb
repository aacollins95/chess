class Piece
  attr_reader :type, :player
  
  def initialize(player, type)
    puts "I make a piece"
    @player = player
    @type = type
  end
end
