require 'rspec'
require 'tile.rb'

describe "Tile#revealed?" do
    it "Returns boolean depending on whether it's revealed or not" do
        tile_1 = Tile.new()
        tile_2 = Tile.new()
        tile_2.reveal
        expect(tile_1.revealed?).to eq (false)
        expect(tile_2.revealed?).to eq (true)
    end
end