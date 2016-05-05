-- import Effects exposing (Never)
-- import Game exposing (init, update, view)
-- import Board exposing (init, update, view)
import Position exposing (init, update, view)
import StartApp.Simple exposing (start)
import Color exposing (..)
import Basics exposing (round)
import Task

type alias PixelsLength = Int

type pixelsLength = 75
main =
  start
    { model = init pixelsLength  darkBrown lightBrown
    , update = update
    , view = view
    }
