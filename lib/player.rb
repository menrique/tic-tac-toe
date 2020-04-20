require 'i18n'

module TicTacToe
  class Player
    attr_accessor :name, :mark

    def initialize(name, mark)
      self.name = name
      self.mark = mark
    end
  end
end