# The Sequence Game

The game consists of a *grid* of any dimension and the seqeunce of
*integers* from 1 to the number of squares in the grid.

# Setup

1.  The grid is initally empty
1.  A random subset of integers is dropped randomly onto the grid:
     * Each integer dropped may land on any square that hasn't been
     already "dropped onto".
     * The number dropped stops when either:
         * two sequential integers (for
            example **5** and **6**) are dropped adjacent to each other either
            vertically or horizontally.
         * If there is no vertical or horizontal sequence created, then the
            dropping stops 1 square short of filling in all the available
            spots on the grid

# Movement Rules

## Definitions

<dl>
<dt>Sequence</dt>
<dd>A sequence of incrementing integers on the grid that
are horizontally and/or vertically adjacent.</dd>
<dt>Minimum Sequence Size</dt>
<dd>The required minimum number of integers in a sequence</dd>
</dl>

## Only Sequences Can Be Moved

Only a **sequence** of a **minimum sequence size** or larger can be moved.

## A Sequence Can Be Dragged Horizontally and/or Vertically

* A sequence can be dragged from either end (i.e. the *smallest*
or *largest* integer in the sequence.
* The end is dragged either *horizontally* or *vertically*.
* Each integer in the sequence occuppies the grid square of its
adjacent integer when moved.  I.e. each integer follows in the
exact path of its sibling ahead of it.

# Objective

To arrange all of the integers into two sequences of ascending
integers displayed horizontally in the grid (and wrapped at the
vertical edges of the grid.

* The *first* of the two sequences places the beginning integer
of the sequence at the *top-left* corner of the grid.  The *ascending*
integers display across from *left to right* and *wrap* as necessary
to the next row.
* A *blank* grid square is left open to the *right* of the *last*
integer in the *first* sequence.
* The *first* integer in the *second* sequence is placed to the
*right* of the above *blank* grid square.
* Subsequent ascending integers in the *second* sequence are displayed
to the right horizontally and wrapped at the end of the grid as
necessary.
* The *last* integer in the *second* sequence occupies the *bottom-right*
square in the grid.

Here's an example of what a finished game would look like:

    |----+----+----+----|
    |  1 |  2 |  3 |  4 |
    |----+----+----+----|
    |  5 |  6 |    |  8 |
    |----+----+----+----|
    |  9 | 10 | 11 | 12 |
    |----+----+----+----|
    | 13 | 14 | 15 | 16 |
    |----+----+----+----|

# Visual Cues

If this is only a logical game, it's likely to be really boring looking.
The following are ideas to "zing" up the appearance:

* Each integer is shown in a diamond background.
* Moving a sequence is a
* When a diamond is dragged around a corner, its slanting edge "slides" on the opposite
edge of the diamond of its sibling integer.
* Visual highlighting shows a sequence on the grid.
