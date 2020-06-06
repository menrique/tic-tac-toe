require './lib/liaison'

describe TicTacToe::Liaison do
  let(:liaison) { TicTacToe::Liaison.new }
  let(:io) { TicTacToe::IO }

  describe '#get_input' do
    # ...
  end

  describe '#get_game_mode' do
    let(:expression) { /^[12]\z/ }
    before do
      allow(liaison).to receive(:get_input).with(
          I18n.t('mode.select'), exp: expression, error: I18n.t('errors.invalid_mode')
      ).and_return(mode)
    end

    context 'when the input is "1"' do
      let(:mode) { '1' }

      it 'should return the given mode' do
        expect(liaison.send(:get_game_mode)).to eq mode
      end
    end

    context 'when the input is "2"' do
      let(:mode) { '2' }

      it 'should return the given mode' do
        expect(liaison.send(:get_game_mode)).to eq mode
      end
    end

    context 'when the input is unknown' do
      let(:mode) { '1' }

      before do
        allow(io).to receive(:read_ln_br).with(I18n.t('mode.select')).and_return(nil, nil, mode)
      end

      it 'should retry getting the input until returns a valid mode' do
        expect(liaison.send(:get_game_mode)).to eq mode
      end
    end
  end

  describe '#get_player_names' do
    # ...
  end
end