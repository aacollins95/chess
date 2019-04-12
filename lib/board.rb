class Board
  attr_reader :squares
  def initialize
    @height, @width = 8,8
    @squares = Hash.new
    (0...@height).each { |r|
      (0...@width).each { |c|
        # print [c,r]
        # puts " "
        @squares[[c,r]] = Square.new([c,r])
      }
    }
  end
end
