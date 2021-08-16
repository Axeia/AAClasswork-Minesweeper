class Tile
    attr_accessor :value

    def initialize(hidden_value = "X")
        @hidden_value = hidden_value
        @revealed = false
        @value = nil
    end

    def reveal
        @revealed = true
    end

    def revealed?
        @revealed
    end

    def to_s
        revealed? ? @value : @hidden_value
    end
end