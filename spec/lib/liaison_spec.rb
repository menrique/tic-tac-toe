describe TicTacToe::Liaison do
  let(:liaison) { TicTacToe::Liaison.new }
  let(:io) { TicTacToe::IO }

  describe '#get_input' do
    let(:label) { 'Enter a value' }
    let(:input) { 'some' }

    before do
      allow(io).to receive(:read_ln_br).with(label).and_return(input)
      allow(io).to receive(:read_ln).with(label).and_return(input)
    end

    context 'reading the input' do
      context 'by default' do
        it 'should read the value using read_ln_br' do
          expect(io).to receive(:read_ln_br).with(label)
          liaison.get_input(label)
        end
      end

      context 'not using a break' do
        it 'should read the value using read_ln' do
          expect(io).to receive(:read_ln).with(label)
          liaison.get_input(label, br: false)
        end
      end
    end

    context 'matching values' do
      context 'by default' do
        it 'should match any input and return its expression' do
          expect(liaison.get_input(label)).to eq /.+/.match(input)
        end
      end

      context 'when passing an expression' do
        let(:exp) { /^[12]\z/ }
        let(:input) { '1' }

        context 'if matches the input' do
          it 'should return the matched expression' do
            expect(liaison.get_input(label, exp: exp)[0]).to eq input
          end
        end

        context 'if does not match the input' do
          before do
            allow(io).to receive(:read_ln_br).with(label).and_return('3', input)
          end

          context 'when the error message is not given' do
            it 'should broadcast an invalid input event with the default error' do
              expect{
                liaison.get_input(label, exp: exp)
              }.to broadcast(:invalid_input, I18n.t('errors.invalid_input'))
            end
          end

          context 'when the error message is not given' do
            let(:error) { 'Ups!' }

            it 'should broadcast an invalid input event with the default error' do
              expect{
                liaison.get_input(label, exp: exp, error: error)
              }.to broadcast(:invalid_input, error)
            end
          end

          it 'should retry until there is a matching expression to return' do
            expect(io).to receive(:read_ln_br).with(label).twice
            expect(liaison.get_input(label, exp: exp)[0]).to eq input
          end
        end
      end
    end
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
  end

  describe '#get_player_names' do
    # ...
  end

  describe '-#get_play_or_cmd' do
    # ...
  end

  describe '-#get_confirmation' do
    # ...
  end
end