#!/usr/bin/env ruby
require 'i18n'
require './lib/io'
require './lib/game'

I18n.load_path << Dir[File.expand_path("./config/locales") + "/*.yml"]

trap('SIGINT')  do
  exit true
end

at_exit do
  TicTacToe::IO.write_ln
  TicTacToe::IO.write_ln(I18n.t('goodbye'))
end

TicTacToe::Game.start
exit true