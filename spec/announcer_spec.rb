require './lib/game'

describe TicTacToe::Announcer do
  let(:game) { TicTacToe::Game.new }
  let!(:announcer) { described_class.new(game) }
  let(:io) { TicTacToe::IO }
  let(:board) { TicTacToe::Board.new }

  context 'handling game events' do

    describe 'on :game_started' do
      it 'should output welcome, show rules and commands on create' do
        expect(io).to receive(:write_ln_br).with(I18n.t('welcome')).ordered
        expect(io).to receive(:write_ln_br).with(I18n.t('rules', board: io.draw(board, plays: true))).ordered
        expect(io).to receive(:write_ln_br).with(I18n.t('commands')).ordered
        game.send(:broadcast, :game_started)
      end
    end

    describe 'on :game_finished' do
      it 'should say goodbye' do
        expect(io).to receive(:write_ln).with("\n#{I18n.t('goodbye')}")
        game.send(:broadcast, :game_finished)
      end
    end

    describe 'on :player_won' do
      let(:player_name) { Faker::Name.name }

      it 'should output the winner player name' do
        expect(io).to receive(:write_ln_br).with(I18n.t('results.winner', player: player_name))
        game.send(:broadcast, :player_won, player_name)
      end
    end

    describe 'on :game_tied' do
      let(:player_name) { Faker::Name.name }

      it 'should output the game end tied' do
        expect(io).to receive(:write_ln_br).with(I18n.t('results.tied'))
        game.send(:broadcast, :game_tied)
      end
    end

    describe 'on :invalid_play' do
      it 'should output the game end tied' do
        expect(io).to receive(:write_ln_br).with(I18n.t('errors.invalid_input'))
        game.send(:broadcast, :invalid_play)
      end
    end

    describe 'on :invalid_player_name' do
      let(:player_name) { Faker::Name.name }

      it 'should output the game end tied' do
        expect(io).to receive(:write_ln_br).with(I18n.t('errors.invalid_name', name: player_name))
        game.send(:broadcast, :invalid_player_name, player_name)
      end
    end

    describe 'on :successful_play' do
      it 'should output the game end tied' do
        expect(io).to receive(:write_ln_br).with(io.draw(board))
        game.send(:broadcast, :successful_play, board)
      end
    end

    describe 'on :help_required' do
      it 'should output the game end tied' do
        expect(io).to receive(:write_ln_br).with(I18n.t('commands')).ordered
        expect(io).to receive(:write_ln_br).with(I18n.t('plays', board: io.draw(board, plays: true))).ordered
        game.send(:broadcast, :help_required, board)
      end
    end

    describe 'on :game_restarting' do
      it 'should output the game is restarting' do
        expect(io).to receive(:write_ln_br).with(I18n.t('restarting'))
        game.send(:broadcast, :game_restarting)
      end
    end

    describe 'on :game_exiting' do
      it 'should output the game is exiting' do
        expect(io).to receive(:write_ln).with(I18n.t('exiting'))
        game.send(:broadcast, :game_exiting)
      end
    end

    describe 'on :players_set' do
      let(:player1_name) { Faker::Name.name }
      let(:player2_name) { Faker::Name.name }

      it 'should output the player names' do
        expect(io).to receive(:write_ln_br).with(I18n.t('players.description', player1: player1_name, player2: player2_name))
        game.send(:broadcast, :players_set, player1_name, player2_name)
      end
    end

    describe 'on :player_played' do
      let(:player_name) { 'Player1' }
      let(:play) { '1a' }

      it 'should output the player name and selected play' do
        expect(io).to receive(:write_ln_br).with("#{player_name}: #{play}")
        game.send(:broadcast, :player_played, player_name, play)
      end
    end
  end
end