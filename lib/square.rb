class Square < Board
  attr_reader :selected, :full, :piece
  def initialize(pos)
    #position is (X,Y)
    @pos = pos
    @full = false
    @selected = false
  end

  def add(piece)
    @full = true
    @piece = piece
    #puts "#{piece.type} has been added to #{@pos}"
  end

  def to_s
    #raise "full squares don't work yet" unless (!@full)
    if @full
      c = Unicode.piece(@piece.player,@piece.type)
    else
      c = Unicode.box(self.is_black)
    end
    color = @selected ? "32" : "0"
    return "\e[#{color}m#{c}\e[0m"
  end

  def is_black
    #would the square at this poition be black if it were empty?
    y_even = @pos[1] % 2 == 0
    x_even = @pos[0] % 2 == 0
    if x_even
      return y_even
    else
      return !y_even
    end
  end

  def select(tf)
    @selected = tf
  end

  def select_tog
    @selected = !@selected
  end
end
