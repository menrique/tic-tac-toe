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
    let(:p1) { I18n.t('players.p1') }
    let(:p2) { I18n.t('players.p2') }
    let(:player1_name) {Faker::Name.name }

    context 'when is against the computer' do
      let(:vs_computer) { true }

      before do
        allow(liaison).to receive(:get_input).with(p1, br: false).and_return(player1_name)
      end

      it 'should return the input player name as first player' do
        expect(liaison.get_player_names(vs_computer).first).to eq player1_name
      end

      it 'should return the computer as second player' do
        expect(liaison.get_player_names(vs_computer).last).to eq I18n.t('players.computer')
      end
    end

    context 'when it is a multi-player game' do
      let(:vs_computer) { false }
      let(:player2_name) {Faker::Name.name }

      before do
        allow(liaison).to receive(:get_input).with(p1, br: false).and_return(player1_name)
        allow(liaison).to receive(:get_input).with(
            p2, exp: /^(?!.*#{player1_name}).*$/, br: false, error: I18n.t('errors.invalid_name', name: player1_name)
        ).and_return(player2_name)
      end

      it 'should return the input player name as first player' do
        expect(liaison.get_player_names(vs_computer).first).to eq player1_name
      end

      it 'should return the computer as second player' do
        expect(liaison.get_player_names(vs_computer).last).to eq player2_name
      end
    end
  end

  describe '#get_play_or_cmd' do
    let(:board) { TicTacToe::Board.new }

    context 'when the current player is the computer' do
      let(:current_player) { TicTacToe::Player.new(Faker::Name.name, 'O', ai: true) }

    end

    context 'when the current player is a human' do
      let(:current_player) { TicTacToe::Player.new(Faker::Name.name, 'X', ai: false) }
      let(:exp) { /\A(?<row>[123])(?<col>[abc])\z|\A(?<cmd>[r?q])\z/ }

      context 'when the input is a play' do
        before do
          allow(liaison).to receive(:get_input).with(
              current_player.name, exp: exp
          ).and_return(exp.match('1a'))
        end

        it 'should return the row, column and no command' do
          expect(liaison.get_play_or_cmd(current_player, board)).to eq({row: '1', col: 'a', cmd: nil})
        end
      end

      context 'when the input is a command' do
        before do
          allow(liaison).to receive(:get_input).with(
              current_player.name, exp: exp
          ).and_return(exp.match('r'))
        end

        it 'should return nil coordinates and the input command' do
          expect(liaison.get_play_or_cmd(current_player, board)).to eq({row: nil, col: nil, cmd: 'r'})
        end
      end
    end
  end

  describe '#get_confirmation' do
    let(:exp) { /^[yn]\z/ }
    
    context 'when the input "y"' do
      before do
        allow(liaison).to receive(:get_input).with(I18n.t('options.play_again'), exp: exp).and_return(exp.match('y'))
      end
      
      it 'should return true' do
        expect(liaison.get_confirmation).to be_truthy
      end
    end
    
    context 'when the input is "n"' do
      before do
        allow(liaison).to receive(:get_input).with(I18n.t('options.play_again'), exp: exp).and_return(exp.match('n'))
      end
      
      it 'should return false' do
        expect(liaison.get_confirmation).to be_falsey
      end
    end
  end
end