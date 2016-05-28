module Main exposing (..)

import Graphics.Element exposing (..)
import Window


main : Signal Element
main =
  Signal.map view Window.dimensions


view : ( Int, Int ) -> Element
view ( w, h ) =
  container w h middle (show (toString ( w, h )))
