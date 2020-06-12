# Tic Tac Toe
> #### A Ruby implementation of the popular noughts and crosses game. 

## Setup
### Download
Please download the game [here](https://github.com/menrique/tic-tac-toe/archive/master.zip), unzip the content, and 
navigate to its root folder:
```bash
cd path/to/tic-tac-toe
```

### Ruby
Before enjoying this game, let's check if we have [Ruby](https://www.ruby-lang.org/en/) installed by running the 
following command:

```bash
ruby -v
```

If Ruby responds with a version number, we can skip the next step.

#### Installation

In case we do not have Ruby installed, we recommend using [RVM](https://rvm.io) (Ruby Version Manager). Please follow 
your specific Operative System instructions from the [RVM install guide](https://rvm.io/rvm/install).

We can find the `.versions.conf` file in the project root folder with the suggested Ruby version and Gemset to use:

```conf
ruby=ruby-2.7.1
ruby-gemset=tic-tac-toe
```

When we navigate to the project folder using `cd path/to/tic-tac-toe`, RVM detects the configuration and advices us on 
how to install the proper Ruby version and Gemset. We can achieve the same by running the following commands:

```bash
rvm install ruby-2.7.1
rvm gemset create tic-tac-toe
rvm use 2.7.1@tic-tac-toe
```

#### Dependencies
Let's then install the Ruby gems manager [Bundler](https://bundler.io/) to fetch the game dependencies:

```bash
gem install bundler
```

```bash
bundle install
```

## Playing the Game
One time we have all dependencies installed, we can run the game starting script:

```bash
ruby path/to/tic-tac-toe/start.rb
```

### Welcome Screen
```
===========================================
| Welcome to Tic-Tac-Toe                  |
| v0.1 (2020)                             |
| https://github.com/menrique/tic-tac-toe |
===========================================

Rules
1. You play the game on a grid board that is 3x3 squares.
2. You are X, and your friend (or the computer) is O.
3. Players take turns putting their marks in empty squares by its coordinates:

1a | 1b | 1c
------------
2a | 2b | 2c
------------
3a | 3b | 3c

4. The first player to get three consecutive marks in a row, column or diagonally is the winner.
5. When all squares are full, the game is over. If no player is the winner, the game ends in a tie.

Commands
r  Restart the game (Keeping same players)
?  Get some help on commands and available plays
q  Quit the game (Ctrl+C)
```

### Players Settings
The game supports two playing modes. The single-player (1), where you goes first one and the
computer acts as second player; and the multi-player mode, where you and your friend take turns to play:

#### Single-Player (1)
```
Select the game mode
Vs computer (1) or multi-player (2): 1

Enter player names
Player 1: John Snow

John Snow will mark with X
Computer will mark with 0
```

#### Multi-Player (2)
```
Select the game mode
Vs computer (1) or multi-player (2): 2

Enter player names
Player 1: John Snow
Player 2: Jane Doe

John Snow will mark with X
Jane Doe will mark with 0
```

### Plays
Valid plays are two-letter coordinates. The first one is the row identified as "1", "2" and "3", and the second letter 
is the column "a", "b" and "c". Let's inspect one example:
```
John Snow: 1a

X |   |
---------
  |   |
---------
  |   |

Computer: 1c

X |   | 0
---------
  |   |
---------
  |   |

John Snow: 3c

X |   | 0
---------
  |   |
---------
  |   | X

Computer: 2b

X |   | 0
---------
  | 0 |
---------
  |   | X

John Snow: 3a

X |   | 0
---------
  | 0 |
---------
X |   | X

Computer: 2a

X |   | 0
---------
0 | 0 |
---------
X |   | X

John Snow: 3b

X |   | 0
---------
0 | 0 |
---------
X | X | X

John Snow is the winner!
```
In case there is a winner or the game ends tied, the players have the choice to play again (y) or exit (n):
```
Do you want to play again? (y/n): n

===========================================
| Thanks for using to Tic-Tac-Toe         |
| Goodbye!                                |
===========================================
```

### Commands
The game also supports commands to restart the game (r), display available commands and plays (?), and quit (q).

#### Help (?)
```
John Snow: ?

Commands
r  Restart the game (Keeping same players)
?  Get some help on commands and available plays
q  Quit the game (Ctrl+C)

Plays
0  | 1b | 0
------------
2a | X  | 2c
------------
X  | 3b | 3c
```

#### Restart (r)
```
John Snow: r

Restarting...

John Snow: 3a

  |   |
---------
  |   |
---------
X |   |
```

#### Quit (q)
```
John Snow: q

Exiting...

===========================================
| Thanks for using to Tic-Tac-Toe         |
| Goodbye!                                |
===========================================
```

## Author

Copyright (c) 2020 [Mario Enrique Sanchez](https://www.linkedin.com/in/mario-enrique-s%C3%A1nchez-749a1a89/)

*Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom
the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission
notice shall be included in all copies or substantial portions of the Software.*