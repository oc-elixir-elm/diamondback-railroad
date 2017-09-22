module Sequence exposing (Model, init)

import Piece


type alias Model =
    List Piece.Model


init : Model
init =
    []
