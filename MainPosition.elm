module MainPosition exposing (..)

import Position exposing (..)
import Color exposing (..)


pixelsAcross =
  70


main =
  Position.view pixelsAcross darkBrown lightBrown
