require_relative './lib/minesweeper.rb'

width, height, num_mines = 10, 20, 50

game = Minesweeper.new(width, height, num_mines)
=begin
x = rand(width)
y = rand(height)
puts "Nao flagado" unless game.flag(x, y)
puts
puts "Nao flagado" unless game.flag(x, y)
=end

while(true)
  if !game.play(rand(width), rand(height))
    game.board_state({xray: true})
    break
  end
  game.board_state
end

=begin
while game.still_playing?
  valid_move = game.play(rand(width), rand(height))
  valid_flag = game.flag(rand(width), rand(height))
  if valid_move or valid_flag
  printer = (rand > 0.5) ? SimplePrinter.new : PrettyPrinter.new
  printer.print(game.board_state)
  end
end

puts "Fim do jogo!"
if game.victory?
  puts "Você venceu!"
else
  puts "Você perdeu! As minas eram:"
  PrettyPrinter.new.print(game.board_state(xray: true))
end
=end