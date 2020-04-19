module TicTacToe
  class Board
    attr_accessor :rows, :columns, :cells

    def initialize
      self.rows = %w(1 2 3)
      self.columns = %w(a b c)
      init_cells
    end

    def set(row, col, mark)
      if (result = valid_coords?(row, col))
        self.cells[row][col] = mark
      end
      result
    end

    def at(row, col)
      cells[row][col]
    end

    def valid_coords?(row, col)
      rows.include?(row) && columns.include?(col) && at(row, col).nil?
    end

    def available_cell?
      rows.any?{|row| columns.any?{|col| cells[row][col].nil?}}
    end

    def reset
      init_cells
    end

    private

    def init_cells
      self.cells = rows.inject({}){|result, row| result[row] = Hash[columns.map{|col| [col, nil]}]; result}
    end
  end
end