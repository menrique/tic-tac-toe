module TicTacToe
  class Liaison
    include Wisper::Publisher

    # Loop until get a valid input
    def get_input(label, exp: /.+/, br: true, error: I18n.t('errors.invalid_input'))
      match = nil

      while match.nil? do
        read_method = br ? :read_ln_br : :read_ln
        match = exp.match(IO.send(read_method, label))
        broadcast(:invalid_input, error) if match.nil?
      end

      match
    end

    # Get the game mode
    def get_game_mode
      get_input(I18n.t('mode.select'), exp: /^[12]\z/, error: I18n.t('errors.invalid_mode'))[0]
    end

    # Get player names
    def get_player_names(vs_computer)
      p1 = I18n.t('players.p1')
      p2 = I18n.t('players.p2')

      player1_name =  get_input(p1, br: false) || p1
      player2_name = vs_computer ? I18n.t('players.computer') : get_input(
          p2, exp: /^(?!.*#{player1_name}).*$/, br: false, error: I18n.t('errors.invalid_name', name: player1_name)
      ) || p2

      [player1_name, player2_name]
    end

    # Get play or command input
    def get_play_or_cmd(current_player, board)
      if current_player.ai?
        row, col = current_player.next_play(board)
        broadcast(:player_played, current_player.name, "#{row}#{col}")
        {row: row, col: col, cmd: nil}
      else
        match = get_input(current_player.name, exp: /\A(?<row>[123])(?<col>[abc])\z|\A(?<cmd>[r?q])\z/)
        {row: match[:row], col: match[:col], cmd: match[:cmd]}
      end
    end

    def get_confirmation
      get_input(I18n.t('options.play_again'), exp: /^[yn]\z/)[0] == 'y'
    end
  end
end