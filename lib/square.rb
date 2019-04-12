class Square
  def initialize(pos)
    #position is (X,Y)
    @pos = pos
    @full = false
    @selected = false
  end

  def to_s
    raise "full squares don't work yet" unless (!@full)
    if @full
      puts "don't touch me leave me alone"
    else
      return Unicode.box(self.is_black)
    end
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
end
