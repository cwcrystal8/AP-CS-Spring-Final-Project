# AP-CS-Spring-Final-Project

## Instructions
How to run:
1. Download the IriDescent directory.
2. In a bash shell, run
~~~~
$ processing IriDescent.pde
~~~~

How to play:
1. Press start to start a game.
2. The randomly generate maze will show, and a pink circle is the runner.
3. Control the runner with the arrow keys.
  * Left will switch the runner's direction to the left
  * Right will switch the runner's direction to the right
  * Up will make the runner jump up if it isn't blocked by a wall
  * Down will make the runner stay still
4. If you reach the top of the screen, the game is over.
5. If you reach the bottom of the maze, you win!
6. Try to win the maze as fast as possible! :) Once you win, press the "High Scores" button to log your high score. Type your name, and press "Enter." If you rank in the top ten, your score will appear on the board.

Good luck!

## Development Log

## 06/06
Completed:
 * Color changing
~~~~~~~
~~~~~~~
In Progress:
 * Maze generation
 * Tokens to speed up/slow down
 * Transportation portals
 * Start page
~~~~~~~
~~~~~~~
Pending:
  * High score board
~~~~~~~
~~~~~~~
Notes: We researched different types of ways to incorporate an evenly changing color scheme into the code, and learned about RGB and HSB. We went with HSB because it allowed us to incrementally change the color without having to deal with sine curves.

## 06/02
Completed:
 * Jumping up
~~~~~~~
~~~~~~~
In Progress:
 * Maze generation
 * Color changing
~~~~~~~
~~~~~~~
Pending:
* Tokens to speed up/slow down
* Transportation portals
* High score board
* Start page
~~~~~~~
~~~~~~~
Notes: Jumping up was initially a roadblock until we incorporated a certain range for the runner to be able to jump within and then relocated it depending on its original direction.

## 06/01
Completed:
 * Key controls to move
 * Falling down
~~~~~~~
~~~~~~~
In Progress:
 * Maze generation
 * Jumping up
~~~~~~~
~~~~~~~
Pending:
* Tokens to speed up/slow down
* Transportation portals
* Color changing
* High score board
* Start page
* Gravity simulation
~~~~~~~
~~~~~~~
Notes:
We incorporated the automatic falling down of the runner every time it encountered a hole.


## 05/30
Completed:
 * Maze class
 * Runner class
 * Basic setup() method and draw() method
~~~~~~~
~~~~~~~
In Progress:
 * Key controls to move
 * Falling down
 * Jumping up
 * Maze generation
~~~~~~~
~~~~~~~
Pending:
 * Tokens to speed up/slow down
 * Transportation portals
 * Color changing
 * High score board
 * Start page
~~~~~~~
~~~~~~~
Notes:
We used a modulus algorithm to simulate the rise of the screen
