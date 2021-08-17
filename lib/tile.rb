require 'colorize'

class Tile
    attr_reader :value
    attr_accessor :flag

    def initialize(hidden_value = "■")
        @hidden_value = hidden_value
        @revealed = false
        @value = nil
        @bomb = false
        @flag = false
    end

    def reveal
        @revealed = true
    end
    
    def value=(new_value)
        @bomb = new_value == '●'
        @value = new_value
    end

    def bombify
        @value = '●'
        @bomb = true
    end

    def is_bomb?
        @bomb
    end

    def revealed?
        @revealed
    end

    def to_s
        if flag
            return '⚑'
        end
        if revealed? 
            case @value 
            when '1'
                @value.blue
            when '2'
                @value.green
            when '3'
                @value.red
            when '●'
                @value.yellow.on_red
            when '■'
                @value.white.on_light_blue
            when '▩'
                @value.black.on_black
            else
                @value
            end
        else 
            @hidden_value
        end
    end
end