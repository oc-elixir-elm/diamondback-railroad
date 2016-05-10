import Graphics.Element
import Position
import Color exposing (..)


pixelsAcross = 70


makePosition : Graphics.Element.Element
makePosition =
  Position.view pixelsAcross darkBrown lightBrown


main =
  makePosition
