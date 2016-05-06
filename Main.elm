-- import Effects exposing (Never)
-- import Game exposing (init, update, view)
-- import Board exposing (init, update, view)
import Position exposing (view)
import Color exposing (..)


pixelsAcross = 75


main =
  view pixelsAcross darkBrown lightBrown
