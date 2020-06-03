require './lib/game'
require './lib/game'

describe TicTacToe::Game do
  let(:game) { described_class.new }
  let(:board_class) { TicTacToe::Board }
  let(:player_class) { TicTacToe::Player }
  let(:io) { TicTacToe::IO }
  let(:players) { [player_class.new('Player1', 'X'), player_class.new('Player2', 'O')] }

  describe '#start' do
    # ...
  end

  describe '#finish' do
    before do
      game
    end

    it 'should say goodbye' do
      expect(io).to receive(:write_ln).with("\n#{I18n.t('goodbye')}")
      game.finish
    end
  end

  describe '-#welcome' do
    it 'should output welcome, show rules and commands on create' do
      expect(io).to receive(:write_ln_br).with(I18n.t('welcome')).ordered
      expect(io).to receive(:write_ln_br).with(I18n.t('rules', board: io.draw(board_class.new, plays: true))).ordered
      expect(io).to receive(:write_ln_br).with(I18n.t('commands')).ordered
      game.send(:welcome)
    end
  end

  describe '-#reset' do
    let(:old_board) { board_class.new }

    before do
      game.board = old_board
      game.players = players
      game.winner_player = players.first
      game.current_player = players.last
      game.send(:reset)
    end

    it 'should initialize a new board' do
      expect(game.board).to be_a board_class
      expect(game.board).to_not eq old_board
    end

    it 'should set the winner player to nil' do
      expect(game.winner_player).to be_nil
    end

    it 'should set the current player to the first' do
      expect(game.current_player).to eq players.first
    end
  end

  describe '-#vs_computer?' do
    context 'when the mode is 1' do
      before do
        game.mode = '1'
      end

      it 'should return true' do
        expect(game.send(:vs_computer?)).to be_truthy
      end
    end

    context 'when the mode is 2' do
      before do
        game.mode = '2'
      end

      it 'should return false' do
        expect(game.send(:vs_computer?)).to be_falsey
      end
    end
  end

  describe '-#multi_player?' do
    context 'when the mode is 2' do
      before do
        game.mode = '2'
      end

      it 'should return true' do
        expect(game.send(:multi_player?)).to be_truthy
      end
    end

    context 'when the mode is 1' do
      before do
        game.mode = '1'
      end

      it 'should return false' do
        expect(game.send(:multi_player?)).to be_falsey
      end
    end
  end

  describe '-#set_players' do
    # ...
  end

  describe '-#play' do
    # ...
  end

  describe '-#winner?' do
    context 'when there is a winner player' do
      before do
        game.winner_player = player_class.new('Player1', 'X')
        game.current_player = game.winner_player
      end

      it 'should return true' do
        expect(game.send(:winner?)).to be_truthy
      end

      it 'should output the winner player name' do
        expect(io).to receive(:write_ln_br).with(I18n.t('results.winner', player: game.current_player.name))
        game.send(:winner?)
      end
    end

    context 'when there is no winner player' do
      it 'should return false' do
        expect(game.send(:winner?)).to be_falsey
      end
    end
  end

  describe '-#tie?' do
    before do
      game.players = players
      game.send(:reset)
    end

    context 'when there are no more available plays' do
      before do
        allow(game.board).to receive(:any_available_play?).and_return(false)
      end

      it 'should return true' do
        expect(game.send(:tie?)).to be_truthy
      end

      it 'should output the proper message' do
        expect(io).to receive(:write_ln_br).with(I18n.t('results.tied'))
        game.send(:tie?)
      end
    end

    context 'when there are available plays' do
      before do
        allow(game.board).to receive(:any_available_play?).and_return(true)
      end

      it 'should return false' do
        expect(game.send(:tie?)).to be_falsey
      end
    end
  end

  describe '-#get_input' do
    # ...
  end

  describe '-#sim_input' do
    let(:label) { 'Player1' }
    let(:input) { '1a' }

    it 'should output a play simulating a player choice' do
      expect(io).to receive(:write_ln_br).with("#{label}: #{input}")
      game.send(:sim_input, label, input)
    end
  end

  describe '-#get_play_or_cmd' do
    # ...
  end

  describe '-#process' do
    context 'when the command is "?"'do
      let(:cmd) { '?' }

      before do
        game.board = board_class.new
      end

      it 'should output available commands and plays' do
        expect(io).to receive(:write_ln_br).with(I18n.t('commands')).ordered
        expect(io).to receive(:write_ln_br).with(I18n.t('plays', board: io.draw(game.board, plays: true))).ordered
        game.send(:process, cmd)
      end
    end

    context 'when the command is "r"'do
      let(:cmd) { 'r' }

      it 'should output a restarting message' do
        expect(io).to receive(:write_ln_br).with(I18n.t('restarting'))
        game.send(:process, cmd)
      end
    end

    context 'when the command is "q"'do
      let(:cmd) { 'q' }

      it 'should quit' do
        expect(game).to receive(:quit)
        game.send(:process, cmd)
      end
    end
  end

  describe '-#winning_play?' do
    let(:row) { '1' }
    let(:col) { 'a' }

    before do
      game.board = board_class.new
    end

    context 'if there is a matching row at given coordinates' do
      before do
        allow(game.board).to receive(:matching_row_at?).with(row, col).and_return(true)
      end

      it 'should return true' do
        expect(game.send(:winning_play?, row, col)).to be_truthy
      end
    end

    context 'if there is a matching column at given coordinates' do
      before do
        allow(game.board).to receive(:matching_column_at?).with(row, col).and_return(true)
      end

      it 'should return true' do
        expect(game.send(:winning_play?, row, col)).to be_truthy
      end
    end

    context 'if there is a matching diagonal at given coordinates' do
      before do
        allow(game.board).to receive(:matching_diagonal_at?).with(row, col).and_return(true)
      end

      it 'should return true' do
        expect(game.send(:winning_play?, row, col)).to be_truthy
      end
    end

    context 'if there are no matching rows, columns and diagonals' do

      it 'should return false' do
        expect(game.send(:winning_play?, row, col)).to be_falsey
      end
    end
  end

  describe'-#next_player' do
    before do
      game.players = players
    end

    context 'when the current player is the first' do
      before do
        game.current_player = players.first
      end

      it 'should return the second player' do
        expect(game.send(:next_player)).to eq game.players.last
      end
    end

    context 'when the current player is the second' do
      before do
        game.current_player = players.last
      end

      it 'should return the first player' do
        expect(game.send(:next_player)).to eq game.players.first
      end
    end
  end

  describe '-#restart?' do
    context 'when the command is "r"'do
      let(:cmd) { 'r' }

      it 'should return true' do
        expect(game.send(:restart?, cmd)).to be_truthy
      end
    end

    context 'when the command is not "r"'do
      let(:cmd) { '?' }

      it 'should return false' do
        expect(game.send(:restart?, cmd)).to be_falsey
      end
    end
  end

  describe '-#play_again?' do
    # ...
  end

  describe '-#quit' do
    it 'should output the proper message and then quit' do
      expect {
        expect(io).to receive(:write_ln).with(I18n.t('quiting'))
        game.send(:quit)
      }.to raise_error SystemExit
    end
  end
end