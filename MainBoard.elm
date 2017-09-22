module MainBoard exposing (..)

import Board exposing (..)
import Html exposing (Html)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
