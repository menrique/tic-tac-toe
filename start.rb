#!/usr/bin/env ruby

require './config/initialize'
require './lib/game'

# Main routine
module TicTacToe

  # Create the instance
  game = Game.new

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