require_relative 'board.rb'

class Minesweeper

    attr_reader :field

    def initialize(width, height, num_mines)
        @field = Board.new(width, height, num_mines)
    end

    def play(x, y)
        if (@field.valid_coordenate(x, y))
            played_valid = @field.play(x, y)
        else
            puts "Coordenada inválida!"
            return false
        end

        if played_valid
            puts "Deu sorte! Continue tentando...\n\n"
        else
            puts "Que pena, você exploriu! O ponto que causou sua derrota está marcado com um 'X'\n\n"
        end

        played_valid
    end

    def board_state(xray=false)
        @field.board_state(xray)
    end

    def flag(x, y)
        if (@field.valid_coordenate(x, y))
            valid_coordenate = @field.flag(x, y)
            self.board_state
        else
            puts "Coordenada inválida!"
            return false
        end

        valid_coordenate
    end

    def still_playing?
        puts "Jogo encerrado! Bora mais uma rodada?" if !@field.still_playing?
    end

    def victory?
        if @field.victory?
            puts "Parabéns! Você venceu o jogo 8-)"
        else
            puts "Que pena! Você perdeu o jovo :("
        end
    end

end