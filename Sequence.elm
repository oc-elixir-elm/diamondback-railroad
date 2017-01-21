module Sequence exposing (Model, init)

import Piece


type alias Model =
    List Piece


init : List Piece
init =
    []
