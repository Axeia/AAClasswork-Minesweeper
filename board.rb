class Board

    def initialize(size = 3, bombs = nil)
        @grid = Array.new(size){ Array.new(size) {'x'} }
        @bombs = bombs || size
        @size = size
        @bomb = '💣'
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