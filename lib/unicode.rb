module Unicode

  def self.piece(player,piece)
    raise "Player isn't 1 or 2" unless (player == 1 or player == 2)
    pieces = {'king'=>['♔','♚'], 'queen'=>['♕','♛'], 'rook'=>['♖','♜'],
              'bishop'=>['♗','♝'], 'knight'=>['♘','♞'], 'pawn'=>['♙','♟']
                }
    raise "Piece doesn't exist in chess" unless (pieces.include?(piece))
    return pieces[piece][player-1]
  end

  def self.box(sel,pos)
    #0 1 2
    #7   3  pos positions in a box
    #6 5 4
    raise "'sel' isn't boolean" unless (!!sel == sel)
    sel = sel ? 1 : 0
    raise "'pos' is out of range [0-7]" unless ((0..7).include?(pos))
    pieces = {0=>['┌','┏'], 1=>['─','	━'], 2=>['┐','┓'], 3=>['│','┃'],
              4=>['┘','┛'], 5=>['─','	━'], 6=>['└','┗'], 7=>['│','┃'],
    }
    return pieces[pos][sel]
  end
end
