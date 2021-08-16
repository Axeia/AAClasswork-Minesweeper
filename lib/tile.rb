class Tile
    def initialize(value = "X")
        @value = value
        @revealed = false
    end

    def reveal
        @revealed = true
    end

    def revealed?
        @revealed
    end

    def to_s

    end
end