require_relative 'cell.rb'

class Board
    
    #Valores definidos para conteúdo/estado da célula
    UNKNOWN_CELL = '-'
    CLEAR_CELL = ' '
    BOMB = '#'
    FLAG = 'F'
    PLAYED_OF_DIED = 'X'

    attr_reader :width
    attr_reader :height
    attr_reader :cells_played
    attr_reader :number_of_mines
    attr_reader :map_of_board
    attr_reader :still_playing
    attr_reader :is_gamer_finished

    def initialize(width, height, number_of_mines)        
        @width = width
        @height = height
        @cells_played = 0
        @number_of_mines = number_of_mines
        @still_playing = true
        @is_gamer_finished = false

        @map_of_board = Array.new(width+1) { Array.new(height+1) }

        for x in (1..width)
            for y in (1..height)
                @map_of_board[x][y] = Cell.new(x, y, UNKNOWN_CELL)
            end
        end

        self.insert_mines_in_board(number_of_mines)
    end
    
    def insert_mines_in_board(number_of_mines)
        num_of_mine_added = 0
        
        #Inserindo minas randomicamente na matriz
        while (num_of_mine_added < number_of_mines) do
            x = Random.new.rand(1..@width)
            y = Random.new.rand(1..@height)

            #Se nessa coordenada já existir uma bomba, irá iterar novamente sem incremento do contador, 
            #evitando duplicidade e sobreposição de bombas, devido aos números sorteados randomicamente
            cell = @map_of_board[x][y]
            if cell.content != BOMB             
                cell.content = BOMB
                num_of_mine_added += 1
            else
                next
            end
        end
    end

    def board_state(xray=false)
        new_xray = xray

        if (new_xray && still_playing?)
            return
        end
        
        for y in (1..height)
            for x in (1..width)
                #print @map_of_board[x][y].state
                cell = @map_of_board[x][y]
                if (cell.state == FLAG)
                    print cell.state
                else
                    if cell.content == BOMB
                        if new_xray
                            print cell.content
                        else
                            print UNKNOWN_CELL
                        end
                    else
                        print cell.content
                    end
                end
            end
            puts
        end
    end
    
    def valid_coordenate(x, y)
        #Retorna false se x ou y estiverem fora dos limites do tabuleiro
        #puts "Validando coordenadas #{x} e #{y}"
        if (x < 1 || x > @width) || (y < 1 || y > @height)
            return false 
        end

        true
    end

    def play(x, y)
        #puts "Coordenadas da jogada #{x} e #{y}"        
        cell = @map_of_board[x][y]

        #Se o conteúdo da célula estiver revelado OU
        #se a célula está no estado flegada, retornará falso
        if cell.content == CLEAR_CELL || cell.state == FLAG
            @still_playing = false
            @is_gamer_finished = true
            return false 
        end

        #Se o conteúdo da célula for um número, pois já recebeu uma jogava,
        #retornará falso
        if cell.content.to_i > 0
            @still_playing = false
            @is_gamer_finished = true
            return false
        end
        
        #Se o conteúdo da célula for uma bomba, retornará falso
        if (cell.content == BOMB)
            @still_playing = false
            @is_gamer_finished = true
            cell.content = PLAYED_OF_DIED
            return false            
        end

        #Faz a jogada nas coordenadas passadas
        do_play_at_board(x, y)

        true
    end

    def do_play_at_board(x, y, number_of_mines_around=0)
        number_of_mines_around = number_of_mines_around

        #if (number_of_mines_around != 0)
        #    return
        #end

        #Pega os valores adjacentes a coordenada da jogada
        adjacent_coord = catch_adjacent_coord(x, y)
        #puts "Coordenada jogada #{x} e #{y}"
        #puts "Coordenadas adjacentes"
        #adjacent_coord.each do |coord|
        #    print coord
        #    puts
        #end

        #Verifica se existe bombas nas coordenadas adjacentes a jogada
        adjacent_coord.each do |coord|
            if valid_coordenate(coord[0], coord[1])
                cell = @map_of_board[coord[0]][coord[1]]
                if cell.content == BOMB
                    #Se houver bomba, será incrementado o contador de bombas adjacentes
                    number_of_mines_around += 1
                end
            end
        end

        #Lógica que irá limpar a célula jogada e suas adjacentes
        #se não houver nenhuma bomba ao redor dela
        if number_of_mines_around == 0
            cell = @map_of_board[x][y]
            cell.content = CLEAR_CELL
            increment_plays

            adjacent_coord.each do |coord|
                if valid_coordenate(coord[0], coord[1])
                    cell = @map_of_board[coord[0]][coord[1]]
                    #Se já houver um numero no conteúdo da célula OU
                    #ela esteja flegada, não precisa ser revelada
                    if (cell.content.to_i > 0) || (cell.state == FLAG)
                        next
                    else
                        cell.content = CLEAR_CELL
                        increment_plays
                    end
                end
            end
        #Se houver bomba, será adicionado a quantidade de bombas existentes
        #ao redor dela na célula jogada
        else
            cell = @map_of_board[x][y]
            cell.content = number_of_mines_around
            increment_plays
        end
    end

    def increment_plays
        @cells_played += 1
    end

    def catch_adjacent_coord(x, y)
        adjacent_coord = [[x-1, y-1], [x, y-1], [x+1, y-1], [x-1, y], [x+1, y], [x-1, y+1], [x, y+1], [x+1, y+1]]
    end

    def flag(x, y)
        cell = @map_of_board[x][y]

        content_of_coord = cell.content
        state_of_coord = cell.state
        
        #Se a celula ainda nao foi clicada e não possui flag, adiciona flag
        if (content_of_coord == UNKNOWN_CELL || content_of_coord == BOMB) && state_of_coord != FLAG
            cell.state = FLAG
            puts "if - Conteudo da coordenada #{content_of_coord} e estado #{state_of_coord}"
            puts "if - Coordenadas flegadas #{x} e #{y}"    
            return true
        #Se a célula já foi flegada, retira a flag e volta para UNKNOWN
        elsif state_of_coord == FLAG
            puts "else - Conteudo da coordenada #{content_of_coord} e estado #{state_of_coord}"
            puts "else - Coordenadas flegadas #{x} e #{y}"    
            cell.state = CLEAR_CELL
            cell.content = UNKNOWN_CELL
            return true
        end

        false
    end

    def still_playing?
        if is_player_winner?
            return false
        end

        if is_game_over? && (not is_player_winner?)
            return false
        end
        
        @still_playing
    end

    def victory?        
        if is_game_over? && is_player_winner?
            return true 
        end

        false
    end

    def is_player_winner?
        total_of_cells_to_play = (@width * @height) - @number_of_mines

        if @cells_played == total_of_cells_to_play
            return true 
        end

        false
    end

    def is_game_over?
        @is_gamer_finished
    end
    
end