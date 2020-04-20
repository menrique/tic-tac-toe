module TicTacToe
  class Board
    attr_accessor :rows, :columns, :cells

    def initialize
      self.rows = %w(1 2 3)
      self.columns = %w(a b c)
      init_cells
    end

    # Cell setter marking given coordinates
    def set(row, col, mark)
      if (result = valid_coords?(row, col))
        self.cells[row][col] = mark
      end
      result
    end

    # Cell getter retrieving given coordinates mark
    def at(row, col)
      cells[row][col]
    end

    # Check if given coordinates are in range and the cell is available
    def valid_coords?(row, col)
      rows.include?(row) && columns.include?(col) && at(row, col).nil?
    end

    # Check if there is any available cell
    def available_cell?
      rows.any?{|row| columns.any?{|col| cells[row][col].nil?}}
    end

    # Check matching row relative to the given coordinates
    def matching_row_at?(row, col)
      value = cells[row][col]
      cells[row].all?{|_, v| v == value}
    end

    # Check matching column relative the to given coordinates
    def matching_column_at?(row, col)
      value = cells[row][col]
      cells.all?{|_, v| v[col] == value}
    end

    # Check matching diagonal relative the to given coordinates
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

    # Reset the boards by cleaning the cells
    def reset
      init_cells
    end

    private

    # Build empty cells
    def init_cells
      self.cells = rows.inject({}){|result, row| result[row] = Hash[columns.map{|col| [col, nil]}]; result}
    end
  end
end