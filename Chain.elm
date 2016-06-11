module Chain exposing (init, view, update, subscriptions)

import Html exposing (Html)
import Html.App


type alias Model =
    List Piece
