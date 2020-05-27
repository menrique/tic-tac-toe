require 'pry'
require 'faker'
require './lib/board'

describe TicTacToe::Board do
  let(:board) { TicTacToe::Board.new }
  let(:rows) { board.rows }
  let(:columns) { board.columns }
  let(:cells) { board.cells }

  let(:row) { board.rows.sample }
  let(:col) { board.columns.sample }

  describe '#rows' do
    it 'should store available rows' do
      expect(board.rows).to eq %w(1 2 3)
    end
  end

  describe '#columns' do
    it 'should store available columns' do
      expect(board.columns).to eq %w(a b c)
    end
  end

  describe '#cells' do
    it 'should combine rows and cells into a 3X3 matrix' do
      expect(board.cells).to eq({'1' => {'a' => nil, 'b' => nil, 'c' => nil},
                                 '2' => {'a' => nil, 'b' => nil, 'c' => nil},
                                 '3' => {'a' => nil, 'b' => nil, 'c' => nil}})
    end
  end

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
        rows.each { |row| columns.each { |col| board.set(row, col, %w{X O}.sample) } }
      end

      it 'should return false' do
        expect(board.any_available_play?).to be_falsey
      end
    end
  end

  describe '#matching_row_at?' do
    context 'when all columns on row 1 have the same mark' do
      before do
        board.set('1', 'a', 'X')
        board.set('1', 'b', 'X')
        board.set('1', 'c', 'X')
      end

      it 'should be true' do
        expect(board.matching_row_at?('1', 'a')).to be_truthy
      end
    end

    context 'when all columns on row 2 have the same mark' do
      before do
        board.set('2', 'a', 'X')
        board.set('2', 'b', 'X')
        board.set('2', 'c', 'X')
      end

      it 'should be true' do
        expect(board.matching_row_at?('2', 'b')).to be_truthy
      end
    end

    context 'when all columns on row 3 have the same mark' do
      before do
        board.set('3', 'a', 'X')
        board.set('3', 'b', 'X')
        board.set('3', 'c', 'X')
      end

      it 'should be true' do
        expect(board.matching_row_at?('3', 'c')).to be_truthy
      end
    end

    context 'when there no row with all columns with the same mark' do
      it 'should return false' do
        expect(board.matching_row_at?(row, col)).to be_falsey
      end
    end

    context 'when the cell coordinates are out of range' do
      it 'should return false' do
        expect(board.matching_row_at?('4', 'd')).to be_falsey
      end
    end
  end

  describe '#matching_column_at?' do
    context "when all rows on columns 'a' have the same mark" do
      before do
        board.set('1', 'a', 'X')
        board.set('2', 'a', 'X')
        board.set('3', 'a', 'X')
      end

      it 'should be true' do
        expect(board.matching_column_at?('1', 'a')).to be_truthy
      end
    end

    context "when all rows on columns 'b' have the same mark" do
      before do
        board.set('1', 'b', 'X')
        board.set('2', 'b', 'X')
        board.set('3', 'b', 'X')
      end

      it 'should be true' do
        expect(board.matching_column_at?('2', 'b')).to be_truthy
      end
    end

    context "when all rows on columns 'c' have the same mark" do
      before do
        board.set('1', 'c', 'X')
        board.set('2', 'c', 'X')
        board.set('3', 'c', 'X')
      end

      it 'should be true' do
        expect(board.matching_column_at?('3', 'c')).to be_truthy
      end
    end

    context 'when there no row with all columns with the same mark' do
      it 'should return false' do
        expect(board.matching_column_at?(row, col)).to be_falsey
      end
    end

    context 'when the cell coordinates are out of range' do
      it 'should return false' do
        expect(board.matching_column_at?('4', 'd')).to be_falsey
      end
    end
  end

  describe '#matching_diagonal_at?' do
    context 'when 1a to 3c diagonal cells have the same mark' do
      before do
        board.set('1', 'a', 'X')
        board.set('2', 'b', 'X')
        board.set('3', 'c', 'X')
      end

      it 'should be true' do
        expect(board.matching_diagonal_at?('2', 'b')).to be_truthy
      end
    end

    context 'when 1c to 3a diagonal cells have the same mark' do
      before do
        board.set('1', 'c', 'X')
        board.set('2', 'b', 'X')
        board.set('3', 'a', 'X')
      end

      it 'should be true' do
        expect(board.matching_diagonal_at?('2', 'b')).to be_truthy
      end
    end

    context 'when there no diagonal has the same mark' do
      it 'should return false' do
        expect(board.matching_diagonal_at?(row, col)).to be_falsey
      end
    end

    context 'when the cell coordinates are out of range' do
      it 'should return false' do
        expect(board.matching_diagonal_at?('4', 'd')).to be_falsey
      end
    end
  end

  describe '#reset' do
    before do
      board.set('2', 'b', 'X')
    end

    it 'should initialize all cells with no value' do
      board.reset
      expect(board.cells.all? { |_, cols| cols.all? { |_, val| val.nil? } }).to be_truthy
    end
  end
end