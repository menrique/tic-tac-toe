require './lib/game'

describe TicTacToe::Game do
  let(:liaison) { TicTacToe::Liaison.new }
  let(:game) { TicTacToe::Game.new(liaison) }
  let(:board_class) { TicTacToe::Board }
  let(:player_class) { TicTacToe::Player }
  let(:io) { TicTacToe::IO }
  let(:players) { [player_class.new('Player1', 'X'), player_class.new('Player2', 'O')] }

  describe '#start' do

    it 'should broadcast the game started, set the playing mode and the players to then play' do
      expect{
        expect(game).to receive(:set_mode).ordered
        expect(game).to receive(:set_players).ordered
        expect(game).to receive(:play).ordered
        game.start
      }.to broadcast(:game_started)
    end
  end

  describe '#finish' do
    it 'should broadcast the game finished' do
      expect{
        game.finish
      }.to broadcast(:game_finished)
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

  describe '-#set_mode' do
    let(:mode) { 1 }

    before do
      allow(liaison).to receive(:get_game_mode).and_return(mode)
    end

    it 'should set the game mode with the one retrieved by the liaison' do
      game.send(:set_mode)
      expect(game.mode).to eq mode
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
    let(:player_names) { [Faker::Name.name, Faker::Name.name] }

    before do
      allow(liaison).to receive(:get_player_names).and_return(player_names)
    end

    context 'when the game mode is vs the computer' do
      before do
        game.mode = '1'
        game.send(:set_players)
      end

      it 'should set the player 1 as a human player with the name provided by the liaison and marking with "X"' do
        player1 = game.players.first
        expect(player1).to be_a player_class
        expect(player1.name).to eq player_names.first
        expect(player1.mark).to eq 'X'
        expect(player1.ai?).to be_falsey
      end

      it 'should set the player 1 as the computer marking with "0"' do
        player2 = game.players.last
        expect(player2).to be_a player_class
        expect(player2.name).to eq player_names.last
        expect(player2.mark).to eq '0'
        expect(player2.ai?).to be_truthy
      end
    end

    context 'when the game mode is multi-player' do
      before do
        game.mode = '2'
        game.send(:set_players)
      end

      it 'should set the player 1 as a human player with the name provided by the liaison and marking with "X"' do
        player1 = game.players.first
        expect(player1).to be_a player_class
        expect(player1.name).to eq player_names.first
        expect(player1.mark).to eq 'X'
        expect(player1.ai?).to be_falsey
      end

      it 'should set the player 2 as a human player with the name provided by the liaison and marking with "0"' do
        player2 = game.players.last
        expect(player2).to be_a player_class
        expect(player2.name).to eq player_names.last
        expect(player2.mark).to eq '0'
        expect(player2.ai?).to be_falsey
      end
    end
  end

  describe '-#process_play' do
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

  describe '-#winner_or_tie_declared' do

    context 'when there is a winner' do
      before do
        game.winner_player = players.first
        allow(game).to receive(:winner?).and_return(true)
      end

      it 'should broadcast the winner' do
        expect{
          game.send(:winner_or_tie_declared)
        }.to broadcast(:player_won, game.winner_player.name)
      end

      it 'should return true' do
        expect(game.send(:winner_or_tie_declared)).to be_truthy
      end
    end

    context 'when the game is a tie' do
      before do
        allow(game).to receive(:tie?).and_return(true)
      end

      it 'should broadcast the game is tied' do
        expect{
          game.send(:winner_or_tie_declared)
        }.to broadcast(:game_tied)
      end

      it 'should return true' do
        expect(game.send(:winner_or_tie_declared)).to be_truthy
      end
    end

    context 'when there is no winner and the game continues' do
      before do
        allow(game).to receive(:winner?).and_return(false)
        allow(game).to receive(:tie?).and_return(false)
      end

      it 'should return false' do
        expect(game.send(:winner_or_tie_declared)).to be_falsey
      end
    end
  end

  describe '-#get_play_or_cmd' do
    # ...
  end

  describe '-#process_cmd' do
    context 'when the command is "?"'do
      let(:cmd) { '?' }

      before do
        game.board = board_class.new
      end

      it 'should broadcast that help is required' do
        expect{
          game.send(:process_cmd, cmd)
        }.to broadcast(:help_required, game.board)
      end
    end

    context 'when the command is "r"'do
      let(:cmd) { 'r' }

      it 'should broadcast the game is restarting' do
        expect{
          game.send(:process_cmd, cmd)
        }.to broadcast(:game_restarting)
      end
    end

    context 'when the command is "q"'do
      let(:cmd) { 'q' }

      it 'should quit' do
        expect(game).to receive(:quit)
        game.send(:process_cmd, cmd)
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
    it 'should broadcast the game is exiting' do
      expect {
        game.send(:quit)
      }.to broadcast(:game_exiting)
    end

    it 'should halt with system exit' do
      expect {
        game.send(:quit)
      }.to raise_error SystemExit
    end
  end
end