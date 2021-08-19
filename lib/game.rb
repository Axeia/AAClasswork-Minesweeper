require_relative 'board.rb'
require 'yaml'

class Game
    attr_accessor :board

    class UserInputError < StandardError; end

    def initialize
        @board = Board.new
        puts "Welcome to minesweeper! \n\nReveal all the cells to win the game "\
        "but beware, if you hit a mine it's game over.\n"\
        "Revealed cells show the number of bombs that around them, use this "\
        "intel to your benefit.\n\n"\
        "The commands are: \n"\
        "- #{'save'.black.on_white}*      To save the game and exit out\n"\
        "- #{'flag 2,3'.black.on_white}** To flag a cell, flagged cells "\
        " cannot be played. Use this to\n #{' '*12}safeguard yourself against "\
        " where you think a bomb is located\n"\
        "- #{'2,3'.black.on_white}**      To just play the cell and hopefully"\
        " not hit a bomb!\n\n"\
        "* The next time you fire up the game it will ask you if you want to"\
        " load up the last one\n"\
        "** The numbers should be comma seperated (no space) and within the "\
        "confines of the board.\n\n"


        @lost = false
        @file_path = File.expand_path("../../saved_games/"\
            + 'game_1.yaml', __FILE__)
    end

    def run
        if File.exists?(@file_path)
            puts "Found saved game " + @file_path
            puts "Would you like to resume this game?"
            load_game if ask_and_got_yes?
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

    def ask_and_got_yes?
        user_input = ''
        begin
            user_input = gets.chomp
            
            raise Game::UserInputError, \
            "You have to answer with either 'Yes' or 'No'"\
            unless is_valid_yes_or_no?(user_input)
            
        rescue Game::UserInputError => e
            puts e.message
            retry
        else        
            return user_input == 'yes'
        end
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

            if user_input == 'save'
                save_game
            elsif user_input.start_with?("flag ")
                place_flag(user_input)
            else
                reveal_node(user_input)
            end
        rescue UserInputError => exception
            puts exception.message
            retry 
        end
    end

    def reveal_node(user_input)
        raise_error_if_invalid_node_str(user_input)
        node = parse_node(user_input)
        puts "Playing: " + user_input
        @lost = @board.reveal_node(node) #Lost if we hit a bomb
    end

    def place_flag(user_input)
        str_flag_pos = user_input[-3..-1]
        raise_error_if_invalid_node_str(str_flag_pos)

        node = parse_node(str_flag_pos)
        if @board.is_flag?(node)
            puts "Unflagging " + str_flag_pos
        else
            puts "Flagging: " + str_flag_pos
        end

        @board.flag_node(node)
    end

    def raise_error_if_invalid_node_str(string)
        raise Game::UserInputError, 
        "Sorry, unrecognized input. It should be two numbers within "\
        "the range of the board \n seperated by a comma. (e.g. 1,1)"\
        unless valid_node?(user_input)
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
    game.run()
end