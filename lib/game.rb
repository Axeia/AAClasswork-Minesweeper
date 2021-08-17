require_relative 'board.rb'
require 'set'

class Game
    attr_accessor :board

    def initialize
        @board = Board.new
        puts "Welcome to minesweeper! Reveal all nodes to win the game but "\
        "beware,"
        puts "if you hit a mine it's game over."
        @lost = false
        @flagged_nodes = Set.new()
    end

    def run
        until won? || lost? 
            puts @board.render
            play_turn
        end

        puts @board.render
        puts "Congratulations! You cleared the board " if won? 
        puts "KABOOM! Better luck next time!" if lost?

        exit
    end

    def won?
        @board.all_non_bombs_revealed?
    end

    def lost?
        @lost
    end

    def play_turn 
        user_input = ''
        node = nil
        flagging_bomb = false
        begin
            user_input = gets.chomp

            if user_input.start_with?("flag ")
                flagging_bomb = true
                user_input = user_input[-3..-1]
            end

            raise "Sorry, unrecognized input. It should be two numbers within "\
            "the range of the board seperated by a comma. (e.g. 1,1)"\
            unless valid_node?(user_input)

            node = parse_node(user_input)
        rescue => exception
            puts exception.message
            retry 
        end

        if flagging_bomb
            puts "Flagging: " + user_input
            @board.flag_node(node)
        elsif @board.is_flag(node)
            puts "Sorry, you previously flagged this node. Use the same "\
            "'flag #{user_input}' command to unflag it to make it playable."
        else
            puts "Playing: " + user_input
            @lost = @board.reveal_node(node) #Lost if we hit a bomb
        end
    end

    def valid_node?(user_input)
        arr = user_input.split(",")
        arr.length == 2 && 
        arr.all?{ |v| is_valid_number?(v) } && 
        @board.in_bounds?([arr[0].to_i, arr[1].to_i])
    end
    
    def is_valid_number?(string)
        ('0'..'9').to_a.include?(string)
    end

    def parse_node(user_input)
        arr = user_input.split(",")
        arr.map(&:to_i)
    end
end


if __FILE__ == $0
    game = Game.new

    # tile_0 = Tile.new()
    # tile_1 = Tile.new()
    # tile_2 = Tile.new()

    # tile_3 = Tile.new()
    # tile_4 = Tile.new()
    # tile_5 = Tile.new()

    # tile_6 = Tile.new()
    # tile_7 = Tile.new()
    # tile_8 = Tile.new()
    # tile_8.bombify
    # grid = [
    #     [tile_0, tile_1, tile_2],
    #     [tile_3, tile_4, tile_5],
    #     [tile_6, tile_7, tile_8]
    # ]

    # game.board.set_grid(grid)

    game.run()
end