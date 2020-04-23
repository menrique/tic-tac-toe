require 'i18n'

module TicTacToe
  class Player
    attr_accessor :name, :mark, :computer

    def initialize(name, mark, computer: false)
      self.name = name
      self.mark = mark
      self.computer = computer
    end

    def computer?
      computer
    end

    def next_play(board)
      block_winning_play(board) || play_to_win(board) || take_corners_if_center(board) || take_center_if_corner(board)
    end

    private

    def block_winning_play(board)
      applicable = true

      if applicable

      end
    end

    def play_to_win(board)
      applicable = true

      if applicable

      end
    end

    def take_corners_if_center(board)
      applicable = board.last_play == %w(2 b)

      if applicable

      end
    end

    def take_center_if_corner(board)
      applicable = board.last_play == %w(1 a) ||
          board.last_play == %w(1 c) ||
          board.last_play == %w(3 a) ||
          board.last_play == %w(3 c)

      if applicable

      end
    end
  end
end