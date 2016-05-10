-- import Effects exposing (Never)
-- import Game exposing (init, update, view)
-- import Board exposing (view)
-- import Board exposing (init, update, view)
import Graphics.Element
import Position
import Color exposing (..)

-- ONly needed when rendering Position
-- pixelsAcross = 75


makePosition : Graphics.Element.Element
makePosition =
  Position.view 70 darkBrown lightBrown


main =
  makePosition
