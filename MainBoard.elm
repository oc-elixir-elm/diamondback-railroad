module MainBoard exposing (..)

import Html.App as Html
import Board exposing (..)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
