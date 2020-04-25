require 'faker'
require './lib/io'

describe TicTacToe::IO do
  let(:msg) { Faker::Lorem.sentence }
  let(:label) { Faker::Lorem.word }
  let(:label_output) { "#{label}: " }
  let(:input) { Faker::Lorem.word }

  before do
    allow(STDIN).to receive(:gets).and_return(input)
    allow(STDOUT).to receive(:write).with(label_output)
  end

  describe '.write' do

    it 'should print the given message' do
      expect{
        TicTacToe::IO.write(msg)
      }.to output(msg).to_stdout
    end
  end

  describe '.write_ln' do

    it 'should puts the given message' do
      expect{
        TicTacToe::IO.write_ln(msg)
      }.to output("#{msg}\n").to_stdout
    end
  end

  describe '.write_ln_br' do

    it 'should puts the given message and break into a new line' do
      expect{
        TicTacToe::IO.write_ln_br(msg)
      }.to output("#{msg}\n\n").to_stdout
    end
  end

  describe '.read_ln' do

    it 'should write the given label as the output format' do
      expect{
        TicTacToe::IO.read_ln(label)
      }.to output(label_output).to_stdout
    end

    context 'when the user enters a value' do
      let(:chomped) { Faker::Lorem.word }
      let(:input) { "#{chomped}\r" }

      it 'should gets and return the chomped input' do
        expect(TicTacToe::IO.read_ln(label)).to eq chomped
      end
    end

    context 'when the user does not enter a value' do
      before do
        allow(STDIN).to receive(:gets).and_return('')
      end

      it 'should return nil' do
        expect(TicTacToe::IO.read_ln(label)).to be_nil
      end
    end
  end

  describe '.read_ln_br' do

    it 'should read_ln the input and then break into a new line' do
      expect(TicTacToe::IO).to receive(:read_ln).with(label).ordered
      expect(TicTacToe::IO).to receive(:write_ln).ordered
      TicTacToe::IO.read_ln_br(label)
    end
  end
end