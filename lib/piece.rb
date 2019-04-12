class Piece < Square
  attr_reader :type, :player

  def initialize(player, type)
    @player = player
    @type = type
  end


end
