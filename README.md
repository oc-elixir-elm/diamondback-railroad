# Diamondback Railroad

Demonstrates a game engine for a visually-pleasing 2-D game.

## Purpose

A group of us is developing this game as an exercise in learning
**[Elm](http://elm-lang.org)**.  We
have evolved to a specific purpose for this game:

> Implement a non-trivial 2-D board game to develop our skills in
> using Elm to drive **svg** and interact w/ HTML in general.

## To Run the Game

**[http://oc-elixir-elm.github.io](http://oc-elixir-elm.github.io)**

## Installation Assumption

1.  **Mac OSX** (Modify installation instructions for Windows and Linux)

## Installation

1.  **[Install Elm 0.17.1](http://elm-lang.org/install)**
1.  Run following commands in your terminal:
``` bash
cd <your elm projects work directory>
git clone git@github.com:oc-elixir-elm/diamondback-railroad.git
cd diamondback-railroad
elm make
elm reactor
```

## "Playing" the Game

Remember, this is simply showing off the game engine that generates
the visualations.

1.  Browse **[http://localhost:8000/MainBoard.elm](http://localhost:8000/MainBoard.elm)**
1.  Move the numbered chain around by typing on the arrow keys.

Here's a "game" challenge if you want one:

1.  Traverse all of the flashing perimeter squares (they will stop flashing
as you traverse them), then...
1.  Move the chain back completely onto the grid inside the perimeter squares.
1.  Don't trap yourself by getting yourself into a situation where you
have nowhere to go but backwards.  Guess what?  You can't go backwards.
1.  If you trap yourself, you have to reload the game by refreshing the page.
1.  Your score is the number of move counts.  A lower score is better.

> Hint: you cannot tranverse all of the permeter squares in one try because
> you will trap yourself.  You have to "dodge" the tail of the chain you
> dragging behind.

Have fun!


## Status

We've implemented most of the game interaction infrastructure including

* The playing board, including flashing squares that invite attention.
* Moving pieces.  These move in a chain like the "snake" game, but not
on their own.  Rather you press arrow keys that move the head of the
chain and the remainder of "the snake" follows behind.
* The snake moves with full animation -- that is, each square flows
smoothly from square to square instead of disappearing from one square
to suddently appear in the next.  Watching a chain containing 81 pieces
animate around the board is *interesting*, to say the least.
* There is a text display below the board that shows the move count.
* Minimum rules prevent moving the chain off of the board or colliding
with the lagging part of the chain itself.
* Running on latest Elm 0.17.1 revision.

### Tested on:

* Mac Safari
* Mac Chrome
* Mac Firefox
* iPhone Safari (display only since no keyboard)

There is lots still not done:

* No actual game yet.
* No rules
* No levels of increaing difficulty.
* Single-player
* No interaction with a web application backend.

## The Wiki

We're slowing growing the
**[wiki](https://github.com/oc-elixir-elm/diamondback-railroad/wiki)**;
feel free to take a look.

## Contributing

Come learn Elm with us and contribute your code and ideas.  Until we develop our own
guidelines, we're loosely following the
**[Contributin to Elm](https://github.com/elm-lang/elm-compiler/blob/master/CONTRIBUTING.md)**
document.

## Credits

* To the Elm team -- Elm rocks!
* To Matthew Griffith for **[elm-style-animation](https://github.com/mdgriffith/elm-style-animation)**;
  vastly eased animation efforts.
