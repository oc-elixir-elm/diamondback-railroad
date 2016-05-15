module Sequence exposing (Model, Action, init)

import Piece exposing (Piece)


type alias Model =
  List Piece


init : List Piece
init =
  []
