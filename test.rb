require_relative './lib/minesweeper.rb'

width, height, num_mines = 10, 20, 50

game = Minesweeper.new(width, height, num_mines)

while game.still_playing?
  #x_p = rand(1..width)
  x_p = Integer(gets.strip)
  #y_p = rand(1..height)
  y_p = Integer(gets.strip)
  puts "Jogada #{x_p} e #{y_p}"
  valid_move = game.play(x_p, y_p)
  puts
  #x_f = rand(1..width)
  x_f = Integer(gets.strip)
  #y_f = rand(1..height)
  y_f = Integer(gets.strip)
  puts "Flag #{x_f} e #{y_f}"
  valid_flag = game.flag(x_f, y_f)

  if valid_move or valid_flag
    #printer = (rand > 0.5) ? SimplePrinter.new : PrettyPrinter.new
    #printer.print(game.board_state)
    game.board_state
  end
  puts
end

puts "Fim do jogo!"
  if game.victory?
    puts "Você venceu!"
  else
    puts "Você perdeu! As minas eram:"
    #PrettyPrinter.new.print(game.board_state(xray: true))
    game.board_state(xray: true)
end

=begin
while(true)
  #x = rand(1..width)
  #y = rand(1..height)
  x = gets.strip
  y = gets.strip
  #puts "Coordenadas sorteadas #{x} e #{y}"

  #if !game.play(rand(width), rand(height))
  if !game.play(Integer(x), Integer(y))
    game.board_state({xray: true})
    break
  end
  game.board_state
end

=begin
for x in (1..width)
  for y in (1..height)
    if !game.play(Integer(x), Integer(y))
      game.board_state({xray: true})
      break
    end
    game.board_state
  end
end
=begin

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