class Cell

    #Classe que representa cada quadrado do campo minado (celula),
    #possuindo os atribudos da posicao x e y e o conteudo dessa celula no tabuleiro
    
    #Definido os atributos como 'att_acessor', permitindo que o ruby crie os metodos
    #set e get para cada propriedade
    attr_accessor :x
    attr_accessor :y
    
    #Definido dois parâmetros para a célula: 
    #conteúdo, que armazenará se a célula possui bomba, já foi descoberta, está vazia ou número de bombas ao redor
    #estado, que armazenará se a célula possui flag ou não
    attr_accessor :content
    attr_accessor :state

    #Construtor da classe Cell
    #As propriedade em ruby podem ser acessadas usando o simbolo '@'
    #para distinguir das variaveis locais
    def initialize(x, y, content, state='')
        @x = x
        @y = y
        @content = content
        @state = state
    end

end