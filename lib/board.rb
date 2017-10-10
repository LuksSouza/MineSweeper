require_relative 'cell.rb'

class Board
    
    #Valores definidos para conteúdo/estado da célula
    UNKNOWN_CELL = '.'
    CLEAR_CELL = ' '
    BOMB = '#'
    FLAG = 'F'
    CELL_OF_DIED = 'X'

    attr_reader :width
    attr_reader :height
    attr_reader :cells_played
    attr_reader :number_of_mines
    attr_reader :map_of_board

    def initialize(width, height, number_of_mines)        
        @width = width
        @height = height
        @number_of_mines = number_of_mines

        @map_of_board = Array.new(width) { Array.new(height) }

        @width.times do |x|
            @height.times do |y|
                @map_of_board[x][y] = Cell.new(x, y, UNKNOWN_CELL)
            end
        end

        self.insert_mines(number_of_mines)
    end
    
    def insert_mines(number_of_mines)
        num_of_mine_added = 0
        
        #Array que armazenará a coordenada de cada mina do campo
        coordenate_of_mines = []
        
        #Inserindo minas randomicamente na matriz
        while (num_of_mine_added < number_of_mines) do
            x = Random.new.rand(0...@width)
            y = Random.new.rand(0...@height)

            #Se nessa coordenada já existir uma bomba, irá iterar novamente sem incremento do contador, 
            #evitando duplicidade e sobreposição de bombas, devido aos números sorteados randomicamente
            cell = @map_of_board[x][y]
            if cell.content != BOMB
                coordenate_of_mines << [x, y]                 
                cell.content = BOMB
                num_of_mine_added += 1
            else
                next
            end
        end

        #print coordenate_of_mines.length
        #puts

        #self.board_state

    end

    def board_state(xray=false)
        new_xray = xray
        
        #if (xray.)

        @width.times do |x|
            @height.times do |y|
                #print @map_of_board[x][y].state
                cell = @map_of_board[x][y]
                if (cell.state == FLAG)
                    print cell.state
                else
                    print cell.content
                end
            end
            puts
        end
    end
    
    def valid_coordenate(x, y)
        #Retorna false se x ou y estiverem fora dos limites do tabuleiro
        #puts "Coordenadas a validar #{x} e #{y}"
        return false if (x < 0 || x > @width) || (y < 0 || y > @height)

        true
    end

    def play(x, y)
        #puts "Coordenadas da jogada #{x} e #{y}"
        cell = @map_of_board[x][y]

        return false if cell.content == CLEAR_CELL || cell.state == FLAG
        
        if (cell.content == BOMB)
            cell.content = CELL_OF_DIED
            return false            
        end

        cell.content = CLEAR_CELL

        true
    end

    def flag(x, y)
        cell = @map_of_board[x][y]

        content_of_coord = cell.content
        state_of_coord = cell.state

        #puts "Conteudo da coordenada #{content_of_coord} e estado #{state_of_coord}"
        #puts "Coordenadas flegadas #{x} e #{y}"

        #Se a celula ainda nao foi clicada e não possui flag, adiciona flag
        if content_of_coord == UNKNOWN_CELL && state_of_coord != FLAG
            cell.state = FLAG
            return true
        #Se a célula já foi flegada, retira a flag e volta para UNKNOWN
        elsif state_of_coord == FLAG
            cell.state = CLEAR_CELL
            cell.content = UNKNOWN_CELL
            return true
        end

        false
    end

    def still_playing?
        #Aqui será implementado a lógica que valida a quantidade de células
        #já descobertas e se o jogador ainda não perdeu
        true
    end

    def victory?
        total_of_cells_to_play = (@width * @height) - @number_of_mines
        return true if @cells_played == total_of_cells_to_play
    end
    
end