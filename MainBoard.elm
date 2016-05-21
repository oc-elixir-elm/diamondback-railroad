module Main exposing (..)

import Html exposing (..)
-- import Graphics.Element exposing (..)
-- import Window
import Board
import Color exposing (..)


main : Html msg
main =
  view (1, 1)


view : ( Int, Int ) -> Html msg
view ( w, h ) =
  Board.view ( w, h )
