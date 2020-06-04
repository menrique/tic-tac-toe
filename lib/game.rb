require 'i18n'
require 'pry'
require 'wisper'

require './lib/io'
require './lib/board'
require './lib/player'
require './lib/announcer'

# Game logic
module TicTacToe
  class Game
    include Wisper::Publisher
    attr_accessor :board, :mode, :players, :current_player, :winner_player, :announcer

    # Start a new game (entry point)
    def start
      broadcast(:game_started)
      set_mode
      set_players
      play
    end

    # Finish the game
    def finish
      broadcast(:game_finished)
    end

    private

    # Reset game
    def reset
      self.board = Board.new
      self.winner_player = nil
      self.current_player = players.first
    end

    # Configure the game mode
    def set_mode
      IO.write_ln(I18n.t('mode.settings'))
      self.mode = get_input(I18n.t('mode.select'), /^[12]\z/)[0]
    end

    # Check is the mode is against the computer
    def vs_computer?
      mode == '1'
    end

    # Check is the mode is multi-player
    def multi_player?
      mode == '2'
    end

    # Configure each player
    def set_players
      IO.write_ln(I18n.t('players.settings'))

      p1 = I18n.t('players.p1')
      p2 = I18n.t('players.p2')

      player1_name = IO.read_ln(p1) || p1
      player2_name = ''

      loop do
        player2_name = vs_computer? ? I18n.t('players.computer') : IO.read_ln_br(p2) || p2
        if player1_name != player2_name
          break
        else
          broadcast(:invalid_player_name, player2_name)
        end
      end

      self.players = [
          player1 = Player.new(player1_name, 'X'),
          player2 = Player.new(player2_name, '0', ai: vs_computer?)
      ]

      IO.write_ln if vs_computer?
      broadcast(:players_set, player1.name, player2.name)
    end

    # Main game loop
    def play
      loop do
        reset
        restart_cmd = false
        until winner_or_tie_declared do
          row, col, cmd = get_play_or_cmd.values
          cmd.nil? ? process_play(row, col) : process_cmd(cmd)
          break if (restart_cmd = restart?(cmd))
        end

        break unless restart_cmd || play_again?
      end
    end

    # Play by marking the current player on given coordinates
    def process_play(row, col)
      if board.set(row, col, current_player.mark)
        next_player unless winning_play?(row, col)
        broadcast(:successful_play, board)
      else
        broadcast(:invalid_play)
      end
    end

    # Check if there is any declared winner
    def winner?
      !self.winner_player.nil?
    end

    # Check if there is no more available play
    def tie?
      !board.any_available_play?
    end

    # Check and declare winner player or tied game
    def winner_or_tie_declared
      if (result = winner?)
        broadcast(:player_won, winner_player.name)
      elsif (result = tie?)
        broadcast(:game_tied)
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
      if current_player.ai?
        row, col = current_player.next_play(board)
        broadcast(:player_played, current_player.name, "#{row}#{col}")
        {row: row, col: col, cmd: nil}
      else
        match = get_input(current_player.name, /\A(?<row>[123])(?<col>[abc])\z|\A(?<cmd>[r?q])\z/)
        {row: match[:row], col: match[:col], cmd: match[:cmd]}
      end
    end

    # Process given command
    def process_cmd(cmd)
      case cmd
      when '?'
        broadcast(:help_required, board)
      when 'r'
        broadcast(:game_restarting)
      else # q
        quit
      end
    end

    # Check if given play wins the game
    def winning_play?(row, col)
      if (result = board.matching_row_at?(row, col) || board.matching_column_at?(row, col) || board.matching_diagonal_at?(row, col))
        self.winner_player = current_player
      end
      result
    end

    # Switch player turns
    def next_player
      self.current_player = (current_player == players.first ? players.last : players.first)
    end

    # Check if the command restart the game
    def restart?(cmd)
      cmd == 'r'
    end

    # Ask if the user wants to play again
    def play_again?
      continue = get_input(I18n.t('options.play_again'), /^[yn]\z/)[0] == 'y'
      process_cmd('r') if continue
      continue
    end

    # Quit the game by exiting
    def quit
      broadcast(:game_exiting)
      exit true
    end
  end
end