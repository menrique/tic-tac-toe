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

    def matching_row_at?(row, col)
      value = cells[row][col]
      cells[row].all?{|_, v| v == value}
    end

    def matching_column_at?(row, col)
      value = cells[row][col]
      cells.all?{|_, v| v[col] == value}
    end

    def matching_diagonal_at?(row, col)
      value = cells[row][col]
      center = cells['2']['b']

      if row == '1' && col == 'a'
        value == center && center == cells['3']['c']
      elsif row == '1' && col == 'c'
        value == center && center == cells['3']['a']
      elsif row == '3' && col == 'a'
        value == center && center == cells['1']['c']
      elsif row == '3' && col == 'c'
        value == center && center == cells['1']['a']
      elsif row == '2' && col == 'b'
        (center == cells['1']['a'] && center == cells['3']['c']) ||
        (center == cells['3']['a'] && center == cells['1']['c'])
      else
        false
      end
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