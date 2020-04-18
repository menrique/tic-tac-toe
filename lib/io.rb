module TicTacToe
  module IO

    def self.draw(board, coords: false)
      empty = ->(row, col, coords){coords ? "#{row}#{col}" : ' '}
      fill = ->(row, col, val, coords){val.nil? ? empty[row, col, coords] : val}

      board.cells.map{|row, cols| cols.map{|col, val| fill[row, col, val, coords]}}.each_with_index.map do |cells, index|
        line = cells.join(' | ')
        separator = "\n#{line.size.times.map{'-'}.join('')}\n" if index < 2
        "#{line}#{separator}"
      end.join('')
    end

    def self.write(msg = nil)
      print msg
    end

    def self.write_ln(msg = nil)
      puts msg
    end

    def self.write_ln_br(msg = nil)
      write_ln(msg)
      write_ln
    end

    def self.read_ln(label)
      write "#{label}: "
      input = STDIN.gets.chomp!
      input == "" ? nil : input
    end

    def self.read_ln_br(label)
      input = read_ln(label)
      write_ln
      input
    end

  end
end