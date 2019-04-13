class Piece < Square
  attr_reader :type, :player, :move_type

  def initialize(player, type)
    @player = player
    @type = type
    #dirs and gmt might not be wholly necessary
    #unecessary, but saving constant data is efficient
    @dirs = get_dirs
    @move_type = get_move_type
  end

  def get_dirs
    case @type
    when 'pawn'
      return [[0,+1]]
    when 'rook'
      return [[0,+1],[+1,0],[0,-1],[-1,0]]
    when 'knight'
      return [[+2,-1],[+2,+1],[+1,-2],[+1,+2],[-1,-2],[-1,+2],[-2,-1],[-2,+1]]
    when 'bishop'
      return [[+1,+1],[+1,-1],[-1,-1],[-1,+1]]
    else
      return [[0,+1],[+1,0],[0,-1],[-1,0],[+1,+1],[+1,-1],[-1,-1],[-1,+1]]
    end
  end

  def get_move_type
    if ['pawn','knight','king'].include?(@type)
      #can only move one 'dir' from its current position
      return 'static'
    else
      #can move many 'dirs' from start as long as it remains on board
      return 'dynamic'
    end
  end


end
