module TicTacToe
  class Board
    attr_accessor :rows, :columns, :cells

    def initialize
      self.rows = %w(1 2 3)
      self.columns = %w(a b c)
      build_cells
    end

    def set(row, col, mark)
      if (validity = valid?(row, col))
        self.cells[row][col] = mark
      end
      validity
    end

    def at(row, col)
      cells[row][col]
    end

    def clean
      build_cells
    end

    def valid?(row, col)
      rows.include?(row) && columns.include?(col) && at(row, col).nil?
    end

    private

    def build_cells
      self.cells = rows.inject({}){|result, row| result[row] = Hash[columns.map{|col| [col, nil]}]; result}
    end
  end
end