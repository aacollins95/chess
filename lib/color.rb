def highlight(text,search_string)
  keywords = search_string.squeeze.strip.split(" ").compact.uniq
  matcher = Regexp.new( '(' + keywords.join("|") + ')' )
  highlighted = text.gsub(matcher) { |match| "<b>#{match}</b>" }
  return highlighted
end

text = "This is an example of the text."
search = "example text"
puts highlight(text,search)

puts "The following word is blue.. \e[34mIm Blue!\e[0m"
puts "The following word is green.. \e[32mIm Green!\e[0m"
puts "The following word is red.. \e[31mIm Red!\e[0m"

# => This is an <b>example</b> of the <b>text</b>.
