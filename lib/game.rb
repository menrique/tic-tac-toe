require 'i18n'
require 'pry'

require './lib/io'
require './lib/board'
require './lib/player'

# Game logic
module TicTacToe
  class Game
    attr_accessor :board, :players, :current_player, :winner_player

    def initialize
      IO.write_ln_br(I18n.t('welcome'))
      IO.write_ln_br(I18n.t('rules', board: IO.draw(Board.new, coords: true)))
      IO.write_ln_br(I18n.t('commands'))
    end

    # Start a new game (entry point)
    def start
      set_players
      loop do
        self.board = Board.new
        self.winner_player = nil
        self.current_player = players.first

        restart_cmd = false
        until any_winner? || tied_game? do
          row, col, cmd = get_play_or_cmd
          cmd.nil? ? play(row, col) : process(cmd)
          break if (restart_cmd = restart?(cmd))
        end

        break unless restart_cmd || play_again?
      end
    end

    # Configure each player
    def set_players
      IO.write_ln(I18n.t('players.settings'))

      p1 = I18n.t('players.p1')
      p2 = I18n.t('players.p2')

      player1_name = IO.read_ln(p1) || p1
      player2_name = ''

      loop do
        player2_name = IO.read_ln_br(p2) || p2
        if player1_name != player2_name
          break
        else
          IO.write_ln_br(I18n.t('errors.invalid_name', name: player2_name))
        end
      end

      self.players = [
          player1 = Player.new(player1_name, 'X'),
          player2 = Player.new(player2_name, '0')
      ]

      IO.write_ln_br(I18n.t('players.description', player1: player1.name, player2: player2.name))
    end

    # Play by marking the current player on given coordinates
    def play(row, col)
      if board.set(row, col, current_player.mark)
        next_player unless winning_play?(row, col)
        IO.write_ln_br(IO.draw(board))
      else
        IO.write_ln_br(I18n.t('errors.invalid_input'))
      end
    end

    # Check if there is any declared winner
    def any_winner?
      if (result = !self.winner_player.nil?)
        IO.write_ln_br(I18n.t('results.winner', player: current_player.name))
      end
      result
    end

    # Check if there is no more available play
    def tied_game?
      if (result = !board.available_cell?)
        IO.write_ln_br(I18n.t('results.tied'))
      end
      result
    end

    # Loop until get a valid input
    def get_input(label, exp)
      match = nil

      while match.nil? do
        match = exp.match(IO.read_ln_br(label))
        IO.write_ln_br(I18n.t('errors.invalid_input')) if match.nil?
      end

      match
    end

    # Get play or command input
    def get_play_or_cmd
      match = get_input(current_player.name, /\A(?<row>[123])(?<col>[abc])\z|\A(?<cmd>[r?q])\z/)
      [match[:row], match[:col], match[:cmd]]
    end

    # Process given command
    def process(cmd)
      case cmd
      when '?'
        IO.write_ln_br(I18n.t('commands'))
        IO.write_ln_br(I18n.t('available_plays', board: IO.draw(board, coords: true)))
      when 'r'
        IO.write_ln_br(I18n.t('restarting'))
      else # q
        quit
      end
    end

    # Check if given play wins the game
    def winning_play?(row, col)
      if board.matching_row_at?(row, col) || board.matching_column_at?(row, col) || board.matching_diagonal_at?(row, col)
        self.winner_player = current_player
      end
    end

    # Switch player turns
    def next_player
      self.current_player = (current_player == players[0] ? players[1] : players[0])
    end

    # Check if the command restart the game
    def restart?(cmd)
      cmd == 'r'
    end

    # Ask if the user wants to play again
    def play_again?
      continue = get_input(I18n.t('options.play_again'), /^[yn]\z/)[0] == 'y'
      process('r') if continue
      continue
    end

    # Quit the game by exiting
    def quit
      IO.write_ln(I18n.t('quiting'))
      exit true
    end

    # Finish the game
    def finish
      IO.write_ln("\n#{I18n.t('goodbye')}")
    end
  end
end