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
        revealed? ? @value : @hidden_value
    end
end