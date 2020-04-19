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

    def start
      loop do
        self.board = Board.new
        self.current_player = players.first
        play
        break unless restart?
      end
      IO.write_ln(I18n.t('goodbye'))
    end

    def set_players
      IO.write_ln(I18n.t('players.setting'))

      player1_name = I18n.t('players.p1')
      player2_name = I18n.t('players.p2')

      self.players = [
          player1 = Player.new(IO.read_ln(player1_name) || player1_name, 'X'),
          player2 = Player.new(IO.read_ln_br(player2_name) || player2_name, '0')
      ]

      IO.write_ln_br(I18n.t('players.description', player1: player1.name, player2: player2.name))
    end

    def play
      until any_winner? || tied_game? do
        row, col = get_coords

        if board.set(row, col, current_player.mark)
          next_player
        else
          IO.write_ln_br(I18n.t('errors.invalid_input'))
        end
      end
    end

    def get_coords
      match = get_cmd(current_player.name, /(?<row>[123])?(?<col>[abc])?/)
      [match[:row], match[:col]]
    end

    def get_cmd(label, exp)
      match = nil

      while match.nil? do
        match = exp.match(IO.read_ln_br(label))
        IO.write_ln_br(I18n.t('errors.invalid_input')) if match.nil?
      end

      match
    end

    def next_player
      IO.write_ln_br(IO.draw(board))
      self.current_player = (current_player == players[0] ? players[1] : players[0])
    end

    def any_winner?
      if (result = 0 > 1)
        IO.write_ln_br(I18n.t('results.winner'))
      end
      result
    end

    def tied_game?
      if (result = !board.available_cell?)
        IO.write_ln_br(I18n.t('results.tied'))
      end
      result
    end

    def restart?
      get_cmd(I18n.t('options.restart'), /^[yn]\z/)[0] == 'y'
    end

    def self.start
      I18n.load_path << Dir[File.expand_path("./config/locales") + "/*.yml"]
      new
    end
  end
end