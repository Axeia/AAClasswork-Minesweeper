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

describe "Tile#value=" do
    it "Tests #value= and #value" do
        tile_1 = Tile.new()
        tile_1.value = '1'
        expect(tile_1.value).to eq ('1')
    end
end

describe "Tile#to_s" do
    it "Tests Tile#to_s, if revealed it should return the value, if not it should return the hidden_value" do
        tile_1 = Tile.new("D")
        tile_1.value = '1'
        expect(tile_1.to_s).to eq ("D")
        tile_1.reveal
        expect(tile_1.to_s).to eq ("1")
    end
end

describe "Tile#bombify" do
    it "Tests Tile#bombify" do
        tile_1 = Tile.new("D")
        tile_1.value = '1'
        expect(tile_1.to_s).to eq ("D")
        tile_1.reveal
        expect(tile_1.to_s).to eq ("1")
        expect(tile_1.is_bomb?).to eq (false)
        tile_1.bombify
        expect(tile_1.to_s).to eq ("●")
        expect(tile_1.is_bomb?).to eq (true)
        tile_1.value = '1'
        expect(tile_1.is_bomb?).to eq (false)
        tile_1.value = '●'
        expect(tile_1.is_bomb?).to eq (true)
    end
end