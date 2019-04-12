module Unicode

  def self.piece(player,piece)

    raise "Player isn't 1 or 2" unless (player == 1 or player == 2)
    pieces = {'king'=>['♔','♚'], 'queen'=>['♕','♛'], 'rook'=>['♖','♜'],
              'bishop'=>['♗','♝'], 'knight'=>['♘','♞'], 'pawn'=>['♙','♟']
                }
    raise "Piece doesn't exist in chess" unless (pieces.include?(piece))
    return pieces[piece][player-1]
  end

  def self.box(filled)
    raise "'filled' isn't boolean" unless (!!filled == filled)
    return filled ? '■' : '□'
  end

end
