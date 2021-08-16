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