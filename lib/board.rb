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
    print "\n" * 15
    (0...@height).reverse_each { |row| draw_row(row)}
    (1..@width).each{ |x| print x.to_s + "   " }
    print "\n"
  end

  def draw_row(y)
    size = 3
    space = " " * size
    (0...@width).each{ |x| print @squares[[x,y]].to_s + space }
    print row_to_letter(y)
    print "\n" + "\n" * (size-2)
  end

  def row_to_letter(row)
    return ("A".ord + row).chr
  end

end
