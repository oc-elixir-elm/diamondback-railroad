module Main exposing (..)
import Board exposing (init, view, update, subscriptions)
import Html.App as Html

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
