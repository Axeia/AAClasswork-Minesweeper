class Board

    def initialize(size = 3, number_of_bombs = nil)
        @grid = Array.new(size){ Array.new(size) {'x'} }
        @number_of_bombs = number_of_bombs || size
        @size = size
        @bomb = '●'
        populate_grid
    end

    def populate_grid()
        add_bombs
        calculate_field_distances_to_bomb
    end

    def add_bombs
        #Generate bomb positions
        bomb_positions = (0...@size).to_a.repeated_permutation(2).to_a.shuffle\
        .take(@number_of_bombs)
        #Place bombs
        bomb_positions.each do |bomb_position| 
            @grid[bomb_position[0]][bomb_position[1]] = @bomb
        end
    end

    def calculate_field_distances_to_bomb
        #todo implement
    end

    def render
        text = '  ' + (0...@size).to_a.join(' ') + "\n"
        # +----------------+ to board size
        divider = " +" + ('-' * ((@size * 2) - 1)) + "+\n"
        text += divider
        @grid.each.with_index do |arr, i| 
            text += i.to_s + "|#{arr.join('|')}|\n#{divider}"
        end
        text
    end
end

if __FILE__ == $0
    board = Board.new()
    puts board.render
end