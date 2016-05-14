import Graphics.Element exposing (..)
import Window
import Board


main : Signal Element
main =
  Signal.map view Window.dimensions


view : (Int,Int) -> Element
view (w,h) =
  container w h middle Board.view
