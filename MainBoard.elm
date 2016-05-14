import Graphics.Element exposing (..)
import Window
import Board
import Color exposing (..)


main : Signal Element
main =
  Signal.map view Window.dimensions


view : (Int,Int) -> Element
view (w,h) =
  Board.view (w,h)
