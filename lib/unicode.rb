module Unicode

  def self.piece(player,piece)
    raise "Player is 1 or 2" unless (player == 1 or player == 2)
    p1 = {'king'=>'♔', 'queen'=>'♕','rook'=>'♖','bishop'=>'♗',
          'knight'=>'♘','pawn'=>'♙'
          }
    p2 = {'king'=>'♚', 'queen'=>'♛','rook'=>'♜','bishop'=>'♝',
          'knight'=>'♞','pawn'=>'♟'
          }
    bw_pieces = [p1,p2]
    return bw_pieces[player-1][piece]
  end

end
