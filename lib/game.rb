require 'i18n'
require 'pry'

require './lib/io'
require './lib/board'
require './lib/player'

module TicTacToe
  class Game
    attr_accessor :board, :players, :current_player

    def initialize
      IO.write_ln_br(I18n.t('welcome'))
      IO.write_ln_br(I18n.t('rules', board: IO.draw(Board.new, coords: true)))
      set_players
      start
    end

    def set_players
      IO.write_ln(I18n.t('enter_players'))

      player1_name = I18n.t('player1')
      player2_name = I18n.t('player2')

      self.players = [
          player1 = Player.new(IO.read_ln(player1_name) || player1_name, 'X'),
          player2 = Player.new(IO.read_ln_br(player2_name) || player2_name, '0')
      ]
      self.current_player = players.first

      IO.write_ln_br(I18n.t('announce_players', player1: player1.name, player2: player2.name))
    end

    def start
      self.board = Board.new
      play
    end

    def play
      until any_winner? do
        row, col = get_coords

        if board.set(row, col, current_player.mark)
          next_player
        else
          IO.write_ln_br(I18n.t('invalid_play'))
        end
      end
    end

    def get_coords
      match = get_cmd(/(?<row>[123])(?<col>[abc])/)
      [match[:row], match[:col]]
    end

    def get_cmd(exp)
      match = nil
      repeat = true

      while repeat do
        match = exp.match(IO.read_ln_br(current_player.name))
        IO.write_ln_br(I18n.t('invalid_play')) if (repeat = match.nil?)
      end

      match
    end

    def next_player
      IO.write_ln_br(IO.draw(board))
      self.current_player = (current_player == players[0] ? players[1] : players[0])
    end

    def any_winner?
      false
    end

    def self.start
      I18n.load_path << Dir[File.expand_path("./config/locales") + "/*.yml"]
      new
    end
  end
end