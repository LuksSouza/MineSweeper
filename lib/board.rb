require_relative 'cell.rb'

class Board
    
    #Valores definidos para conteúdo/estado da célula
    UNKNOWN_CELL = '.'
    CLEAR_CELL = ' '
    BOMB = '#'
    FLAG = 'F'
    PLAYED_OF_DIED = 'X'

    #Propriedades da Classe
    #width
    #height
    #cells_played
    #number_of_mines
    #map_of_board
    #is_still_playing
    #is_gamer_finished

    def initialize(width, height, number_of_mines)        
        @width = width
        @height = height
        @cells_played = 0
        @@cells_already_played = 0
        @@total_of_unknown_cells = width * height
        @number_of_mines = number_of_mines
        @is_still_playing = true
        @is_gamer_finished = false

        @map_of_board = Array.new(width+1) { Array.new(height+1) }

        for x in 1..@width
            for y in 1..@height
                @map_of_board[x][y] = Cell.new(x, y, UNKNOWN_CELL)
            end
        end

        insert_mines_in_board number_of_mines
    end
    
    #Método responsável por inserir minas randomicamente no campo,
    #de acordo com a quantidade passada na construção do objeto
    def insert_mines_in_board(number_of_mines)
        num_of_mine_added = 0
        
        while num_of_mine_added < number_of_mines do
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

    #Método responsável por construir o layout do tabuleiro, exibindo ou não
    #as bombas, de acordo com o parâmetro xray que é opcional
    def board_state(xray=false)
        board_state_content = ""

        if (xray && still_playing?)
            return
        end
        
        for y in 1..@height
            board_state_content << "|"
            for x in 1..@width
                cell = @map_of_board[x][y]
                if cell.state == FLAG
                    board_state_content << cell.state
                else
                    if cell.content == BOMB
                        if xray
                            board_state_content << cell.content.to_s
                        else
                            board_state_content << UNKNOWN_CELL
                        end
                    else
                        board_state_content << cell.content.to_s
                    end
                end
            end
            board_state_content << "|"
            board_state_content << "\n"
        end
        board_state_content
    end

    #Método estático que retornará informações sobre a Engine
    #para ser consumido pelas classes pretty_printer e simple_printer
    def self.get_engine_information
        engine_information = ""

        15.times do
            engine_information << "="
        end

        cells_already_played = @@cells_already_played.to_s
        total_of_unknown_cells_of_board = @@total_of_unknown_cells.to_s

        engine_information << "\nSignificado de cada símbolo no Campo Minado:"
        engine_information << "\nCélula desconhecida: #{UNKNOWN_CELL}"
        engine_information << "\nCélula descoberta: #{CLEAR_CELL}"
        engine_information << "\nCélula com bomba: #{BOMB}"
        engine_information << "\nCélula com flag: #{FLAG}"
        engine_information << "\nVocê já descobriu #{cells_already_played} de #{total_of_unknown_cells_of_board}\n"

        15.times do
            engine_information << "="
        end

        engine_information
    end
    
    #Método responspavel por validar se as coordenadas em questão estão
    #dentro do tabuleiro do jogo
    def is_valid_coordenate?(x, y)
        if (x < 1 || x > @width) || (y < 1 || y > @height)
            return false 
        end

        true
    end

    #Método que inicia o processo de jogada em uma determinada coordenada do tabuleiro
    def play(x, y)
        cell = @map_of_board[x][y]

        #Se o conteúdo da célula estiver revelado OU
        #se a célula está no estado flegada, retornará falso
        if cell.content == CLEAR_CELL || cell.state == FLAG
            @is_still_playing = false
            @is_gamer_finished = true
            return false 
        end

        #Se o conteúdo da célula for um número, pois já recebeu uma jogava
        #e existe bombas ao redor dessa coordenada, retornará falso
        if cell.content.to_i > 0
            @is_still_playing = false
            @is_gamer_finished = true
            return false
        end
        
        #Se o conteúdo da célula for uma bomba, retornará falso e avisará
        # o jogador sobre a derrota
        if (cell.content == BOMB)
            @is_still_playing = false
            @is_gamer_finished = true
            cell.content = PLAYED_OF_DIED
            puts "BOOM! Você acertou uma bomba, fim de jogo :("
            return false            
        end

        #Faz a jogada nas coordenadas passadas
        do_play_at_board(x, y)

        true
    end

    #Método que verifica as célular ao redor da coordenada jogada e
    #retorna o número de bombas ao redor OU desencadeira a lógica de expansão
    def do_play_at_board(x, y)
        adjacent_coord = catch_adjacent_coord x, y

        number_of_mines_around = find_out_bombs_and_set adjacent_coord
        
        clear_adjacent_cells x, y, adjacent_coord, number_of_mines_around
    end

    def catch_adjacent_coord(x, y)
        adjacent_coord = [[x-1, y-1], [x, y-1], [x+1, y-1], [x-1, y], [x+1, y], [x-1, y+1], [x, y+1], [x+1, y+1]]
    end

    #Método que retorna a quantidade de bombas ao redor de determinada coordenada
    def find_out_bombs_and_set(adjacent_coord)
        number_of_mines_around = 0

        #Verifica se existe bombas nas coordenadas adjacentes a jogada
        adjacent_coord.each do |coord|
            if is_valid_coordenate? coord[0], coord[1]
                cell = @map_of_board[coord[0]][coord[1]]
                if cell.content == BOMB
                    #Se houver bomba, será incrementado o contador de bombas adjacentes
                    number_of_mines_around += 1
                end
            end
        end
        
        number_of_mines_around
    end

    #Método que insere o número de bombas na célula jogada OU
    #dispara o processo de revelar as células vazias
    def clear_adjacent_cells(x, y, adjacent_coord, number_of_mines_around)
        cell = @map_of_board[x][y]
        
        #Se houver bomba, será adicionado a quantidade de bombas existentes
        #na da célula jogada
        if number_of_mines_around != 0
            cell.content = number_of_mines_around
            increment_plays
            return number_of_mines_around
    
        #Lógica que irá limpar a célula jogada e suas adjacentes
        #se não houver nenhuma bomba ao redor dela       
        else
            cell.content = CLEAR_CELL
            increment_plays

            adjacent_coord.each do |coord|
                if is_valid_coordenate?(coord[0], coord[1])
                    cell = @map_of_board[coord[0]][coord[1]]
                    #Se já houver um numero no conteúdo da célula OU
                    #ela esteja flegada, não precisa ser revelada
                    if cell.content.to_i > 0 || cell.state == FLAG || cell.content == CLEAR_CELL 
                        next
                    end
                    
                    cell.content = CLEAR_CELL
                    #Chamada ao método play para limpar as células aplicáveis
                    #ao redor das células viinhas da coordenada jogada,
                    #utilizando recursividade, até encontrar uma bomba
                    do_play_at_board coord[0], coord[1]
                end
            end
        end
    end

    def increment_plays
        @cells_played += 1
        @@cells_already_played = @cells_played
    end

    #Método que irá flegar uma coordenada
    def flag(x, y)
        cell = @map_of_board[x][y]

        content_of_coord = cell.content
        state_of_coord = cell.state
        
        #Se a celula ainda não foi clicada e não possui flag, adiciona flag
        if (content_of_coord == UNKNOWN_CELL || content_of_coord == BOMB) && state_of_coord != FLAG
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
        if is_player_winner?
            return false
        end

        if is_game_over? && (not is_player_winner?)
            return false
        end
        
        @is_still_playing
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