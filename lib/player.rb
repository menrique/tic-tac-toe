module TicTacToe
  class Player
    attr_accessor :name, :mark, :ai

    def initialize(name, mark, ai: false)
      self.name = name
      self.mark = mark
      self.ai = ai
    end

    # Check if the player behaves as the computer
    def ai?
      ai
    end

    # Get the next play based on different strategies
    def next_play(board)
      row, col = nil, nil

      if board.any_available_play?
        [:play_to_win, :block_opponent_winning_play, :take_corners, :take_center, :take_edges].any? do |strategy|
          row, col = send(strategy, board)
          !row.nil? && !col.nil?
        end
      end

      [row, col]
    end

    private

    # Execute block simulating a given play
    def simulate_play(board, row, col, mark)
      if block_given?
        args = {validate: false, track: false}
        board.set(row, col, mark, **args)
        yield
        board.set(row, col, nil, **args)
      end
    end

    # Find a winning play using the given mark
    def find_winning_play(board, winning_mark)
      winning_row, winning_col = nil, nil

      board.cells.any? do |row, cols|
        cols.any? do |col, mark|
          if mark.nil?
            winning_play = false

            simulate_play(board, row, col, winning_mark) do
              winning_play = board.matching_row_at?(row, col) ||
                  board.matching_column_at?(row, col) || board.matching_diagonal_at?(row, col)
            end

            if winning_play
              winning_row = row
              winning_col = col
            end

            winning_play
          end
        end
      end

      [winning_row, winning_col]
    end

    # Find a play blocking the opponent winning play
    def block_opponent_winning_play(board)
      row, col = nil, nil
      latest_play = board.latest_play

      if latest_play
        latest_mark = board.at(*latest_play)
        row, col = find_winning_play(board, latest_mark)
      end

      [row, col]
    end

    # Find a winning play
    def play_to_win(board)
      find_winning_play(board, mark)
    end

    # Find any available corner
    def take_corners(board)
      row, col = nil, nil
      
      [%w(1 a), %w(1 c), %w(3 a), %w(3 c)].any? do |corner_row, corner_col|
        row, col = board.available_at?(corner_row, corner_col) ? [corner_row, corner_col] : []
        !row.nil? && !col.nil?
      end

      [row, col]
    end

    # Try the center
    def take_center(board)
      board.available_at?('2', 'b') ? %w(2 b) : [nil, nil]
    end

    # Find any available corner
    def take_edges(board)
      row, col = nil, nil

      [%w(1 b), %w(2 a), %w(2 c), %w(3 b)].any? do |corner_row, corner_col|
        row, col = board.available_at?(corner_row, corner_col) ? [corner_row, corner_col] : []
        !row.nil? && !col.nil?
      end

      [row, col]
    end
  end
end