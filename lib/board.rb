class Board
  attr_reader :squares
  def initialize
    @height, @width = 8,8
    @squares = Hash.new
    (0...@height).each { |r|
      (0...@width).each { |c|
        @squares[[c,r]] = Square.new([c,r])
      }
    }
  end

  def draw_board
    draw_row(0)
  end

  def draw_row
  end

end
