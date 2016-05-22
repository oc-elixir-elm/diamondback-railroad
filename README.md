# Welcome

## What Just Happened?

I've recently opened up this Elm game I'm developing the the Orange County
(Calif) Elixir/Elm group as we've recently been working on this in a weekly
hackfest.

## Purpose

A group of us is developing this game as an exercise in learning Elm.  We
have evolved to a specific purpose for this game:

> Implement a non-trivial 2-d board game to develop our skills in
> using Elm to drive **Svg** and interact w/ HTML in general.

## Status

We are still working on the board logistics, including animation.  There
is no "game theory" implemented yet, although there are documents strewn
around discussing possibilities.

Presently there are too many branches; I'll prune these down soon.
In the meantime, as of May 21, 2016, the most recent branch is the
**working** branch quickly named as the group started an exploratory
detour to more rapidly get the next functionality of the game running.

This was branched from the **elm17** branch where the game was converted
from Elm 0.16 to 0.17.  Along the way, we switched from using the
**[Graphics.Element](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Graphics-Element)** package under Elm 0.16 to the
**[Svg](https://github.com/elm-lang/svg)** and
**[Html](https://github.com/elm-lang/html)** modules under
0.17.

There is a lot of cleanup of branches and code we won't ever use to be
done; hopefully I'll get to it soon.

## What's the remainder of this README?

The remainder of this document is a rambling attempt to capture the
ideas, vocabulary, and design justifications for the implementation of
the game.

> ENJOY!

# The Sequence Game

Name ideas:

* Diamondback Railroad

## Consists of:

* A *grid* consisting of a matrix of squares.
* A *perimeter* of squares that runs around the grid.  The background color
of the perimiter is set differently from the grid to tell them apart.
* Around the perimeter is a *frame* that provides a decorative border
around the game.
I'm thinking about extending the right or bottom siide of the frame to
contain a *console* to control the game.
* The *board* consists of the combination of the grid and perimeter.
* *Pieces* numbered in *ascending* order.  Each piece occupies a square on the
board.  There are no pieces in the perimeter at the beginning of the game
nor at the end; the perimeter is used for "temporary" piece transit during the
game.

There are less pieces than squares, so there are *empty* squares in the grid.

## Object of Game

The object of the game is to move the pieces around on the board so that
they are packed at the top of the board in ascending order

Hence, if we start with an initial game of:

``` none
|---|---|---|
| - | 4 | - |
|---|---|---|
| 3 | - | 5 |
|---|---|---|
| - | 1 | 2 |
|---|---|---|
```

the objective is to move them around until you have

``` none
|---|---|---|
| 1 | 2 | 3 |
|---|---|---|
| - | 5 | 4 |
|---|---|---|
| - | - | - |
|---|---|---|
```

There are movement rules.

The difficulty of the game is increased by initially providing more pieces to
constrict movement.

## Variation

For *difficult* games (meaning initially having so many pieces that there are
few empty squares), a *perimiter* of empty squares is provided around the grid.

For example:

``` none
|---|---|---|---|---|
|   |   |   |   |   |
|---|---|---|---|---|
|   | - | 4 | - |   |
|---|---|---|---|---|
|   | 3 | - | 5 |   |
|---|---|---|---|---|
|   | - | 1 | 2 |   |
|---|---|---|---|---|
|   |   |   |   |   |
|---|---|---|---|---|
```

In this game, pieces can temporarily be moved onto the perimiter on their way to
their final locations.

# Movement Rules

## Definitions

<dl> <dt>Sequence</dt> <dd>A sequence of pieces whose names are in sequence.
The pieces on the sequence are horizontally and/or vertically adjacent.</dd>
<dt>Minimum Sequence Size</dt> <dd>The required minimum number of pieces in a
sequence for it to be moveable</dd> </dl>

## Only Sequences Can Be Moved

*Implication*: At the beginning of the game, a sequence of a minimum sequence
size must already exist on the board

## A Sequence Can Be Dragged Horizontally and/or Vertically

* A sequence can be dragged from either end of the sequence.
* The end is dragged one grid square at a time either *horizontally* or
  *vertically* but not *diagnally*. The end piece dragged is called the *head*
  of the sequence and the remaining pieces are called the *tail*.
*  Each piece in the sequence follows the grid square of its adjacent *parent*
piece when moved.  I.e. each piece "lands" in the exact path of its parent
piece ahead of it.  The head piece has no parent.

## A Sequence can be dragged into the perimeter

In this way, it can be moved from one side of the grid
to the other.

## A Sequence may be split

Presume the *minimum sequence length* is 3.

Given the game-in-progress:

``` none
|---|---|---|---|---|
|   |   |   |   |   |
|---|---|---|---|---|
|   | - | 6 | 4 |   |
|---|---|---|---|---|
|   | 5 | - | 3 |   |
|---|---|---|---|---|
|   | - | 1 | 2 |   |
|---|---|---|---|---|
|   |   |   |   |   |
|---|---|---|---|---|
```

If I split the sequence 1,2,3,4 by dragging the piece labeled "2" down one
square, then the game will look like:

``` none
|---|---|---|---|---|
|   |   |   |   |   |
|---|---|---|---|---|
|   | - | 6 | - |   |
|---|---|---|---|---|
|   | 5 | - | 4 |   |
|---|---|---|---|---|
|   | - | 1 | 3 |   |
|---|---|---|---|---|
|   |   |   | 2 |   |
|---|---|---|---|---|
```

What just happened?

1.  The player dragged the piece labeled "2" down one square.
1.  The game examined the two resulting sequences:
      * 1,2
      * 2,3,4
1.  Since the minimum sequence length is 3, it preserved the length by choosing
    the longer sequence 2,3,4.
1.  If both resulting sequences satisfy the minimu sequence length, then the
    game will ask the player which sequence he prefers.

The purpose of this is to allow dragging smaller sequences so that
the resulting sequence can fit inside the inner grid when there would otherwise
not be sufficient empty squares to complete the maneuver.

## Capturing

When a sequence of pieces is moved by "dragging" the head of the sequence
horizontally or vertically, the last piece in the tail may pass adjacently to a
next piece.  When this happens, the next piece is automatically added to the end
of the tail. If the next piece is also the head of a sequence, then its tail is
"dragged" along alos.

Example: Reconnect the two sequences we created in the previous example.

Given:

``` none
|---|---|---|---|---|
|   |   |   |   |   |
|---|---|---|---|---|
|   | - | 6 | - |   |
|---|---|---|---|---|
|   | 5 | - | 4 |   |
|---|---|---|---|---|
|   | - | 1 | 3 |   |
|---|---|---|---|---|
|   |   |   | 2 |   |
|---|---|---|---|---|
```

If the player moves the piece "4" up one square, the result will look as it did
before.

``` none
|---|---|---|---|---|
|   |   |   |   |   |
|---|---|---|---|---|
|   | - | 6 | 4 |   |
|---|---|---|---|---|
|   | 5 | - | 3 |   |
|---|---|---|---|---|
|   | - | 1 | 2 |   |
|---|---|---|---|---|
|   |   |   |   |   |
|---|---|---|---|---|
```

And, if he drags the "4" up one more square, observe the "1" follow behind:

``` none
|---|---|---|---|---|
|   |   |   | 4 |   |
|---|---|---|---|---|
|   | - | 6 | 3 |   |
|---|---|---|---|---|
|   | 5 | - | 2 |   |
|---|---|---|---|---|
|   | - | - | 1 |   |
|---|---|---|---|---|
|   |   |   |   |   |
|---|---|---|---|---|
```

# Visual Cues

If this is only a logical game, it's likely to be really boring looking.
The following are ideas to "zing" up the appearance:

* Each piece is shown in a diamond background.  Its "ID" is shown in the middle
  of it.
* Moving a sequence is a smooth transition over a period of time.
* When a diamond is dragged around a corner, its slanting edge "slides" on the
opposite edge of the diamond of its sibling integer.
* Visual highlighting shows a sequence on the grid.  Part of the highlighting is
  that the background of the diamond is a color that is only slightly different
  from its parent.

## Color Gradient

There is a separate module that calculates the smooth gradient of the background
color. Each piece's color is calculated using the following algorithm:

1. Divide the total piece count by 3; call this the *phase count*.  So if there
   is a total of **81** pieces, then the phase count is **27**.
1. Presume that each color has 256 shades.
1. Initialize the 3 colors to their initial values.  For illustrative purposes,
presume that we're setting each of the colors to a non-zero minimum value (don't
want to start w/ black), say `0x20`.
1. Select a non-saturated maximum value for each color, say `0xE0`.
1. Divide the range within the minimum and maximum values by the phase count.
This is the *phase step* value.
1. Each piece's background color is different from its parent by the *phase
step* value in one or two of its background colors.
1. Hence, in the first of the 3 phases, the color of each piece is changed by
*phase step* for *phase count* times for one of the colors, say *red*.
1. In the next of the 3 phases, the gradient is subtracted for *red* but added
for *green*.
1. Im the last of the 3 phases, the gradient is subtracted for *green* but added
for blue.  During this time, *red* stays at its minimum value.

We'll probably want to experiement with this.
