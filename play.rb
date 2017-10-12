require_relative './lib/minesweeper.rb'
require_relative './lib/pretty_printer.rb'
require_relative './lib/simple_printer.rb'

width, height, num_mines = 10, 20, 50
#width, height, num_mines = 8, 8, 10

game = Minesweeper.new(width, height, num_mines)

while game.still_playing?
    x_p = rand(1..width)
    #x_p = Integer(gets.strip)
    y_p = rand(1..height)
    #y_p = Integer(gets.strip)
    puts "Jogada coluna #{x_p} e linha #{y_p}"
    valid_move = game.play(x_p, y_p)
    x_f = rand(1..width)
    #x_f = Integer(gets.strip)
    y_f = rand(1..height)
    #y_f = Integer(gets.strip)}"
    puts "Flag coluna #{x_f} e linha #{y_f}"
    valid_flag = game.flag(x_f, y_f)
    puts
    if valid_move or valid_flag
        SimplePrinter.new.print(game.board_state)
        puts game.board_state
    end
    puts
end

puts "Fim do jogo!"
    if game.victory?
        puts "Você venceu!"
    else
        puts "Você perdeu! As minas eram:"
        PrettyPrinter.new.print(game.board_state(xray: true))
end