module Sequence (Model, Action, init) where

import Piece exposing (Piece)


type alias Model =
  List Piece


init : List Piece
init =
  []
