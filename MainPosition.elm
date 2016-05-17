module MainPosition exposing (..)

import Html exposing (Html)
import Html.App as Html
import Position exposing (init, subscriptions, update, view)


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
