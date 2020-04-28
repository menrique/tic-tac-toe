require 'faker'
require './lib/board'

describe TicTacToe::Board do
  let(:board) { TicTacToe::Board.new }
  let(:rows) { board.rows }
  let(:columns) { board.columns }
  let(:cells) { board.cells }

  let(:row) { board.rows.sample }
  let(:col) { board.columns.sample }

  describe '#set' do

    context 'when the cell is available' do
      it 'should return true' do
        expect(board.set(row, col, 'X', validate: true)).to be_truthy
      end

      it 'should set the cell value' do
        board.set(row, col, 'X', validate: true)
        expect(board.cells[row][col]).to eq 'X'
      end

      context 'when play tracking is true' do
        it 'should store current play as latest play tracked' do
          board.set(row, col, 'X', track: true)
          expect(board.latest_play).to eq [row, col]
        end
      end

      context 'when play tracking is false' do
        it 'should not store current play as latest play tracked' do
          board.set(row, col, 'X', track: false)
          expect(board.latest_play).to_not eq [row, col]
        end
      end
    end

    context 'when the cell is occupied' do
      before do
        board.cells[row][col] = 'X'
      end

      context 'when validation is true' do

        it 'should return false' do
          expect(board.set(row, col, 'O', validate: true)).to be_falsey
        end

        it 'should not override the cell value' do
          board.set(row, col, 'O', validate: true)
          expect(board.cells[row][col]).to eq 'X'
        end
      end

      context 'when the validation is false' do

        it 'should return true' do
          expect(board.set(row, col, 'O', validate: false)).to be_truthy
        end

        it 'should set the cell value' do
          board.set(row, col, 'O', validate: false)
          expect(board.cells[row][col]).to eq 'O'
        end

        context 'when play tracking is true' do
          it 'should store current play as latest play tracked' do
            board.set(row, col, 'O', validate: false, track: true)
            expect(board.latest_play).to eq [row, col]
          end
        end

        context 'when play tracking is false' do
          it 'should not store current play as latest play tracked' do
            board.set(row, col, 'O', validate: false, track: false)
            expect(board.latest_play).to_not eq [row, col]
          end
        end
      end
    end

    context 'when the cell coordinates are out of range' do
      let(:row) { '4' }
      let(:col) { 'd' }

      it 'should return false anyway' do
        expect(board.set(row, col, 'X')).to be_falsey
      end

      context 'when play tracking is true' do
        it 'should not store current play as latest play tracked' do
          board.set(row, col, 'X', track: true)
          expect(board.latest_play).to_not eq [row, col]
        end
      end

      context 'when play tracking is false' do
        it 'should not store current play as latest play tracked' do
          board.set(row, col, 'X', track: false)
          expect(board.latest_play).to_not eq [row, col]
        end
      end
    end
  end

  describe '#at' do

    context 'when the cell coordinates are in range' do

      context 'when there is any cell value' do
        before do
          board.set(row, col, 'X')
        end

        it 'should return the cell value' do
          expect(board.at(row, col)).to eq 'X'
        end
      end

      context 'when there is no cell value' do

        it 'should return the cell value' do
          expect(board.at(row, col)).to be_nil
        end
      end
    end

    context 'when the cell coordinates are out of range' do

      it 'should return nil' do
        expect(board.at('4', 'd')).to be_nil
      end
    end
  end

  describe '.available_at?' do

    context 'when there is no cell value' do

      it 'should return true' do
        expect(board.available_at?(row, col)).to be_truthy
      end
    end

    context 'when there is any cell value' do
      before do
        board.set(row, col, 'X')
      end

      it 'should return false' do
        expect(board.available_at?(row, col)).to be_falsey
      end
    end

    context 'when the cell coordinates are out of range' do

      it 'should return false' do
        expect(board.available_at?('4', 'd')).to be_falsey
      end
    end
  end

  describe '#in_range?' do

    context 'when the cell coordinates are in range' do

      it 'should return true' do
        expect(board.in_range?(row, col)).to be_truthy
      end
    end

    context 'when the cell coordinates are out of range' do

      it 'should return false' do
        expect(board.in_range?('4', 'd')).to be_falsey
      end
    end
  end

  describe '#any_available_play?' do

    context 'when there is at least one available cell' do

      it 'should return true' do
        expect(board.any_available_play?).to be_truthy
      end
    end

    context 'when there are not available cell' do
      before do
        rows.each{|row| columns.each{|col| board.set(row, col, %w{X O}.sample)}}
      end

      it 'should return false' do
        expect(board.any_available_play?).to be_falsey
      end
    end
  end

  describe '#matching_row_at?' do

    context 'when all columns on row 1 have the same mark' do

    end

    context 'when all columns on row 2 have the same mark' do

    end

    context 'when all columns on row 3 have the same mark' do

    end

    context 'when there no row with all columns with the same mark' do

      it 'should return false' do
        expect(board.matching_row_at?(row, col)).to be_falsey
      end
    end
  end
end