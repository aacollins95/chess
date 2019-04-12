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

  #draw methods and helpers
  def draw_board
    #"\e[#{color}m#{c}\e[0m"
    print "\n" * 15
    (0...@height).reverse_each { |row| draw_row(row)}
    print "   "
    (0...@width).each{ |x| print "\e[34m#{row_to_letter(x)}\e[0m" + "  " }
    print "\n"
  end

  def draw_row(y)
    size = 2
    space = " " * size
    print "\e[34m#{y}\e[0m" + space
    (0...@width).each{ |x| print @squares[[x,y]].to_s + space }
    print "\n" + "\n" * (size-1)
  end

  def row_to_letter(row)
    raise "row needs to be in range" until (0...@height).include?(row)
    #gets letter of a particular
    return ("A".ord + row).chr
  end

end
