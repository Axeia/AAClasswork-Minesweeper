class Tile
    attr_reader :value

    def initialize(hidden_value = "■")
        @hidden_value = hidden_value
        @revealed = false
        @value = nil
        @bomb = false
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
        revealed? ? @value : @hidden_value
    end
end