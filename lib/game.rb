require_relative 'board.rb'
require 'yaml'

class Game
    attr_accessor :board

    def initialize
        @board = Board.new
        puts "Welcome to minesweeper! Reveal all nodes to win the game but "\
        "beware,"
        puts "if you hit a mine it's game over."
        @lost = false
        @file_path = File.expand_path("../../saved_games/"\
             + 'game_1.yaml', __FILE__)
    end

    def run
        if File.exists?(@file_path)
            puts "Found saved game " + @file_path
            puts "Would you like to resume this game?"
            load_game if ask_for_yes_or_no?
        end

        until won? || lost? 
            puts @board.render
            play_turn
        end

        puts @board.render
        puts "Congratulations! You cleared the board " if won? 
        puts "KABOOM! Better luck next time!" if lost?

        exit
    end

    def ask_to_run
        puts "Would you like to resume? Yes/No"

    end

    def ask_for_yes_or_no?
        user_input = ''
        begin
            user_input = gets.chomp
            raise "You have to answer with either yes or no!"\
            unless is_valid_yes_or_no?(user_input)

        rescue => exception
            puts exception.message
            retry
        end
        
        user_input == 'yes'
    end

    def is_valid_yes_or_no?(user_input)
        user_input.downcase == 'yes' || user_input.downcase == 'no' 
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

            save_game if user_input == 'save'

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

    def save_game
        puts "Saving game " + @file_path  
        File.write(@file_path, @board.to_yaml)
        exit
    end

    def load_game
        puts "Loading game " + @file_path
        @board = YAML::load(File.read(@file_path))
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