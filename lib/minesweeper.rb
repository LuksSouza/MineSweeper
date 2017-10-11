require_relative 'board.rb'

class Minesweeper

    def initialize(width, height, num_mines)
        @board = Board.new(width, height, num_mines)
    end

    def play(x, y)
        return false if @board.is_game_over?

        if (@board.valid_coordenate(x, y))
            played_valid = @board.play(x, y)
        else
            puts "Coordenada inválida!"
            return false
        end

        #if played_valid
        #    puts "Jogada Válida!\n\n"
        #else
        #    puts "Jogada Inválida!\n\n"
        #end

        played_valid
    end

    def board_state(xray=false)
        return if @board.is_game_over? && xray == false

        @board.board_state(xray)
    end

    def flag(x, y)
        return false if @board.is_game_over?

        if (@board.valid_coordenate(x, y))
            valid_coordenate = @board.flag(x, y)
            #self.board_state
        else
            puts "Coordenada inválida!"
            return false
        end

        valid_coordenate
    end

    def still_playing?
        return false if @board.is_game_over?

        @board.still_playing?
    end

    def victory?
        return false if @board.is_game_over?

        if @board.victory?
            puts "Parabéns! Você venceu o jogo 8-)"
        else
            puts "Que pena! Você perdeu o jovo :("
        end
    end

end