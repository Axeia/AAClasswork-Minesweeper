require_relative 'tile.rb'

class Board

    def initialize(size = 9, number_of_bombs = nil)
        @grid = Array.new(size){ Array.new(size) { Tile.new() } }
        number_of_bombs = number_of_bombs || size
        @size = size
        populate_grid(number_of_bombs)
    end

    # For debugging / checking methods behave as expected in rspec
    # Include bomb fields.
    def set_grid(grid)
        @grid = grid
        @size = grid.length
        calculate_number_of_neighbouring_bombs
    end

    def populate_grid(number_of_bombs)
        add_bombs(number_of_bombs)
        calculate_number_of_neighbouring_bombs
    end

    def reveal
        @grid.flatten.each{ |tile| tile.reveal }
    end

    def calculate_number_of_neighbouring_bombs
        @grid.each.with_index do |row, v|
            row.each.with_index do |tile, h|
                unless tile.is_bomb?
                    tile.value = adjacent_bomb_count([v, h]).to_s
                end
            end
        end
    end

    def add_bombs(number_of_bombs)
        #Generate bomb positions
        bomb_positions = (0...@size).to_a.repeated_permutation(2).to_a.shuffle\
        .take(number_of_bombs)
        #Place bombs
        bomb_positions.each do |bomb_position| 
            @grid[bomb_position[0]][bomb_position[1]].bombify
        end
    end

    def adjacent_bomb_count(node)
        count = 0
        adjacent_nodes(node).each do |node_index| 
            v, h = node_index
            count += 1 if @grid[v][h].is_bomb?
        end
        count
    end

    def adjacent_nodes(node)
        v, h = node
        adjacent_nodes = []
        
        possibly_adjacent_nodes = {
            :top_left_node     => [v-1, h-1],
            :top_node          => [v-1, h],
            :top_right_node    => [v-1, h+1],

            :left_node         => [v, h-1],
            :right_node        => [v, h+1],
    
            :bottom_left_node  => [v+1, h-1],
            :bottom_node       => [v+1, h],
            :bottom_right_node => [v+1, h+1]
        }
        possibly_adjacent_nodes.select{ |k, adj_node| in_bounds?(adj_node) }\
        .values
    end

    def in_bounds?(node)        
        v, h = node
        return false unless v >= 0 and v < @size 
        #Change this if support for non-square boards is ever added
        return false unless h >= 0 and h < @size 
        true
    end

    def calculate_field_distances_to_bomb
        #todo implement
    end

    def render
        text = '   ' + (0...@size).to_a.join(' ') + "\n"
        # +----------------+ to board size
        divider = "  +" + ('-' * ((@size * 2) - 1)) + "+\n"
        text += divider
        @grid.each.with_index do |arr, i| 
            text += i.to_s + ' |'
            arr.each{ |tile| text += tile.to_s + '|' }
            text += "\n#{divider}"
        end
        text
    end

    # Returns true is the node was a bomb
    def reveal_node(v,h, visited_nodes = [])
        if in_bounds?([v, h])
            @grid[v][h].reveal
            if @grid[v][h].is_bomb?
                return true
            else
                adj_bomb_count = adjacent_bomb_count([v,h])
                if adj_bomb_count > 0
                    @grid[v][h].value = adj_bomb_count.to_s
                else
                    @grid[v][h].value = '▩'

                    # riple outwards
                    nodes_adjacent_nodes = adjacent_non_bomb_nodes([v, h])
                    nodes_adjacent_nodes.each do |n| 
                        next if visited_nodes.include?(n)
                        visited_nodes << n
                        reveal_node(n[0], n[1], visited_nodes)
                    end
                end
            end
        end

        false
    end

    def adjacent_non_bomb_nodes(node)
        nodes = adjacent_nodes(node)
        nodes.delete_if{ |v| @grid[v[0]][v[1]].is_bomb? }
        nodes
    end

    def bombs_revealed?
        return @grid.flatten.any?{ |tile| tile.is_bomb? && tile.revealed? }
    end

    def all_non_bombs_revealed?
        return @grid.flatten.all? do |tile| 
            (tile.is_bomb? && !tile.revealed?) || 
            (tile.revealed? && !tile.is_bomb?)
        end
    end
end

if __FILE__ == $0
    board = Board.new(9, 9)
    # board.reveal
    board.reveal_node(4, 3)
    puts board.render
    board.reveal
    puts board.render
end