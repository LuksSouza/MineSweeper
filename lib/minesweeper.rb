require_relative 'board.rb'

class Minesweeper

    def initialize(width, height, num_mines)
        @board = Board.new(width, height, num_mines)
    end

    def play(x, y)
        return false if @board.is_game_over?

        if @board.is_valid_coordenate? x, y
            played_valid = @board.play x, y
        else
            puts "Coordenada inválida!"
            return false
        end

        played_valid
    end

    def board_state(xray=false)
        return if @board.is_game_over? && xray == false

        @board.board_state xray
    end

    def flag(x, y)
        return false if @board.is_game_over?

        if @board.is_valid_coordenate? x, y
            valid_coordenate = @board.flag x, y
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
            puts "Que pena! Você perdeu o jogo :("
        end
    end

    def self.get_engine_information
        Board.get_engine_information
    end
end