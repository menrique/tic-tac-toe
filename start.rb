#!/usr/bin/env ruby

require './config/initialize'

# Main routine
module TicTacToe

  # Create the game with the players liaison and announcer
  game = Game.new(Liaison.new)
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