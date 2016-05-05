-- import Effects exposing (Never)
-- import Game exposing (init, update, view)
-- import Board exposing (init, update, view)
import Position exposing (init, update, view)
import StartApp.Simple exposing (start)
import Task


main =
  start
    { model = init
    , update = update
    , view = view
    }
