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
    attr_accessor :board, :mode, :players, :current_player, :winner_player, :announcer, :liaison

    def initialize(liaison)
      self.liaison = liaison
    end

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
      self.mode = liaison.get_game_mode
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
      player1_name, player2_name = liaison.get_player_names
      self.players = [
          player1 = Player.new(player1_name, 'X'),
          player2 = Player.new(player2_name, '0', ai: vs_computer?)
      ]
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
        broadcast(:invalid_input)
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

    # Get play or command input
    def get_play_or_cmd
      if current_player.ai?
        row, col = current_player.next_play(board)
        broadcast(:player_played, current_player.name, "#{row}#{col}")
        {row: row, col: col, cmd: nil}
      else
        match = liaison.get_input(current_player.name, exp: /\A(?<row>[123])(?<col>[abc])\z|\A(?<cmd>[r?q])\z/)
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
      continue = liaison.get_input(I18n.t('options.play_again'), exp: /^[yn]\z/)[0] == 'y'
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