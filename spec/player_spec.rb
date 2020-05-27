require 'pry'
require 'faker'
require './lib/player'

describe TicTacToe::Player do
  let(:name) { Faker::Name.first_name }
  let(:ai) { false }
  let(:player) { TicTacToe::Player.new(name, 'X', ai: ai) }
  let(:board) { TicTacToe::Board.new }

  describe '#name' do
    it 'should store the player name' do
      expect(player.name).to eq name
    end
  end

  describe '#mark' do
    it 'should store the player mark' do
      expect(player.mark).to eq 'X'
    end
  end

  describe '#ai' do
    it 'should store if the player acts like an artificial intelligence' do
      expect(player.ai).to eq ai
    end
  end

  describe '#ai?' do
    context 'when the player is set to be human' do
      let(:ai) { false }

      it 'should return false' do
        expect(player.ai?).to be_falsey
      end
    end

    context 'when the player is set to be an artificial intelligence' do
      let(:ai) { true }

      it 'should return true' do
        expect(player.ai?).to be_truthy
      end
    end
  end

  describe '#next_play' do
    let(:fill_board) { ->() {
      board.rows.each do |row|
        board.columns.each do |col|
          board.set(row, col, %w{X O}.sample)
        end
      end
    }}

    context 'when there are available plays' do
      it 'should return a coordinate' do
        expect(player.next_play(board).compact.size).to eq 2
      end
    end

    context 'when there are not available plays' do
      before do
        fill_board.call
      end

      it 'should return empty coordinates' do
        expect(player.next_play(board)).to eq [nil, nil]
      end
    end
    
    context 'when applying strategies' do
      before do
        fill_board.call
      end
      
      context ':play_to_win' do
        context 'if there is an available winning play' do
          before do
            board.cells = {'1' => {'a' => 'X', 'b' => 'X', 'c' => nil},
                           '2' => {'a' => nil, 'b' => 'O', 'c' => nil},
                           '3' => {'a' => 'O', 'b' => nil, 'c' => nil}}
          end

          it 'should return the winning play' do
            expect(player.next_play(board)).to eq %w{1 c}
          end
        end

        context 'if there is no winning play' do
          it 'should return empty coordinates' do
            expect(player.next_play(board)).to eq [nil, nil]
          end
        end
      end

      context ':block_opponent_winning_play when no :play_to_win is possible' do
        context 'if there is a potential opponent winning play' do
          before do
            board.cells = {'1' => {'a' => nil, 'b' => nil, 'c' => 'X'},
                           '2' => {'a' => nil, 'b' => 'O', 'c' => nil},
                           '3' => {'a' => 'X', 'b' => nil, 'c' => 'O'}}
          end

          it 'should return the blocked opponent winning play' do
            expect(player.next_play(board)).to eq %w{1 a}
          end
        end

        context 'if there is no winning play' do
          it 'should return empty coordinates' do
            expect(player.next_play(board)).to eq [nil, nil]
          end
        end
      end

      context ':take_corners when no :play_to_win and :block_opponent_winning_play are possible' do
        context 'if there is an available corner' do
          before do
            board.cells = {'1' => {'a' => 'O', 'b' => 'X', 'c' => 'O'},
                           '2' => {'a' => 'O', 'b' => nil, 'c' => 'X'},
                           '3' => {'a' => 'X', 'b' => nil, 'c' => nil}}
          end

          it 'should return a corner' do
            expect(player.next_play(board)).to eq %w{3 c}
          end
        end

        context 'if there is no available corner' do

          it 'should return empty coordinates' do
            expect(player.next_play(board)).to eq [nil, nil]
          end
        end
      end

      context ':take_center when no :play_to_win, :block_opponent_winning_play and :take_corners are possible' do
        context 'if there center is available' do
          before do
            board.cells = {'1' => {'a' => 'O', 'b' => 'X', 'c' => 'O'},
                           '2' => {'a' => 'O', 'b' => nil, 'c' => nil},
                           '3' => {'a' => 'X', 'b' => 'O', 'c' => 'X'}}
          end

          it 'should return the center' do
            expect(player.next_play(board)).to eq %w{2 b}
          end
        end

        context 'if there is no available corner' do

          it 'should return empty coordinates' do
            expect(player.next_play(board)).to eq [nil, nil]
          end
        end
      end

      context ':take_edges when no :play_to_win, :block_opponent_winning_play, :take_corners and :take_center are possible' do
        context 'if there center is available' do
          before do
            board.cells = {'1' => {'a' => 'O', 'b' => 'X', 'c' => 'O'},
                           '2' => {'a' => nil, 'b' => 'X', 'c' => nil},
                           '3' => {'a' => 'X', 'b' => 'O', 'c' => 'X'}}
          end

          it 'should return an edge' do
            expect(player.next_play(board)).to eq %w{2 a}
          end
        end

        context 'if there is no available corner' do

          it 'should return empty coordinates' do
            expect(player.next_play(board)).to eq [nil, nil]
          end
        end
      end
    end
  end
end