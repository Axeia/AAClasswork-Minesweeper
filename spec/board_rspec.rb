require 'rspec'
require 'board.rb'

describe "Board#in_bounds" do
    it "Checks if given node is in bounds of the grid" do
        # Creates board 
        #[0,0][0,1][0,2]
        #[1,0][1,1][1,2]
        #[2,0][2,1][2,2]
        board = Board.new(3)
        expect(board.in_bounds?([0,3])).to eq (false)
        expect(board.in_bounds?([2,3])).to eq (false)
        expect(board.in_bounds?([5,1])).to eq (false)

        expect(board.in_bounds?([0,0])).to eq (true)
        expect(board.in_bounds?([0,1])).to eq (true)
        expect(board.in_bounds?([0,2])).to eq (true)
        expect(board.in_bounds?([1,0])).to eq (true)
        expect(board.in_bounds?([1,1])).to eq (true)
        expect(board.in_bounds?([1,2])).to eq (true)
        expect(board.in_bounds?([2,0])).to eq (true)
        expect(board.in_bounds?([2,1])).to eq (true)
        expect(board.in_bounds?([2,2])).to eq (true)
    end
end

describe "Board#adjacent_nodes" do
    it "Gets the nodes adjacent to the given one" do
        board = Board.new(3)
        expect(board.adjacent_nodes([0,0])).to eq ([
                  [0,1], 
            [1,0],[1,1]
        ])
        expect(board.adjacent_nodes([1,1])).to eq([
            [0,0],[0,1],[0,2],
            [1,0],      [1,2],
            [2,0],[2,1],[2,2]
        ])
        expect(board.adjacent_nodes([2,1])).to eq([

            [1,0],[1,1],[1,2],
            [2,0],      [2,2]
        ])
    end
end

tile_0 = Tile.new()
tile_1 = Tile.new()
tile_2 = Tile.new()

tile_3 = Tile.new()
tile_4 = Tile.new()
tile_5 = Tile.new()

tile_6 = Tile.new()
tile_7 = Tile.new()
tile_8 = Tile.new()
tile_8.bombify
grid = [
    [tile_0, tile_1, tile_2],
    [tile_3, tile_4, tile_5],
    [tile_6, tile_7, tile_8]
]

board = Board.new()
test_grid = grid.dup

describe "Board#set_grid" do
    it "Check if set_grid behaves as expected, the method itself is needed \ 
    for further spec testing" do
        board.set_grid(test_grid)
    end
end

describe "Board#all_non_bombs_revealed?" do
    it "True if all fields except the bombs are showing (the win condition)" do
        expect(board.all_non_bombs_revealed?).to eq(false)
    end
end

describe "Board#reveal_node" do
    it "Checks if the node gets revealed and if it's neighbouring cells get \
    revealed if they aren't a bomb. If they are their value should be the\
    number of bombs" do
        expect(board.reveal_node([0,0])).to eq(false) 
        expect(tile_0.revealed?).to eq (true)
        expect(tile_1.revealed?).to eq (true)
        expect(tile_2.revealed?).to eq (true)    
        expect(tile_3.revealed?).to eq (true)    
        expect(tile_6.revealed?).to eq (true)
        
        expect(tile_4.revealed?).to eq (true)
        expect(tile_4.value).to eq ("1")
        expect(tile_5.revealed?).to eq (true)
        expect(tile_5.value).to eq ("1")
        expect(tile_7.revealed?).to eq (true)
        expect(tile_7.value).to eq ("1")

        # Bomb should be hidden still
        expect(tile_8.revealed?).to eq (false)
    end
end

describe "Board#all_non_bombs_revealed?" do
    it "True if all fields except the bombs are showing (the win condition)" do
        expect(board.all_non_bombs_revealed?).to eq(true)
    end
end

describe "Board#bombs_revealed?" do
    it "True if a (any) bomb is revealed - the loss condition" do
        expect(board.bombs_revealed?).to eq(false)        
        expect(board.reveal_node([2,2])).to eq(true) # Hitting bomb
        expect(board.bombs_revealed?).to eq (true)
    end
end
