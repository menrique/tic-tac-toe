module TicTacToe
  class Announcer

    # Subscribe to given game on create
    def initialize(game)
      game.subscribe(self)
      game.liaison.subscribe(self)
    end

    # Game events to announce

    def game_started
      IO.write_ln_br(I18n.t('welcome'))
      IO.write_ln_br(I18n.t('rules', board: IO.draw(Board.new, plays: true)))
      IO.write_ln_br(I18n.t('commands'))
    end

    def game_finished
      IO.write_ln("\n#{I18n.t('goodbye')}")
    end

    def player_won(player_name)
      IO.write_ln_br(I18n.t('results.winner', player: player_name))
    end

    def game_tied
      IO.write_ln_br(I18n.t('results.tied'))
    end

    def invalid_input(message = I18n.t('errors.invalid_input'))
      IO.write_ln_br(message)
    end

    def successful_play(board)
      IO.write_ln_br(IO.draw(board))
    end

    def help_required(board)
      IO.write_ln_br(I18n.t('commands'))
      IO.write_ln_br(I18n.t('plays', board: IO.draw(board, plays: true)))
    end

    def game_restarting
      IO.write_ln_br(I18n.t('restarting'))
    end

    def game_exiting
      IO.write_ln(I18n.t('exiting'))
    end

    def players_set(player1_name, player2_name)
      IO.write_ln_br("\n#{I18n.t('players.description', player1: player1_name, player2: player2_name)}")
    end

    def player_played(player_name, play)
      IO.write_ln_br("#{player_name}: #{play}")
    end
  end
end