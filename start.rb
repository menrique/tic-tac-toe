#!/usr/bin/env ruby

require './config/initialize'
require './lib/game'

# Main routine
module TicTacToe

  # Create the game and its announcer
  game = Game.new
  Announcer.new(game)

  # Intersect exit signal and avoid interruption error
  trap('SIGINT')  do
    exit true
  end

  # Finish the game as exiting routine
  at_exit do
    game.finish
  end

  # Start the game
  game.start

  # Exit after the game ends normally
  exit true
end