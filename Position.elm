module Position (..) where

import Graphics.Collage exposing (..)
import Graphics.Element
import Color exposing (..)


-- import Html exposing ()


type alias PixelsAcross =
  Int


type alias BorderColor =
  Color


type alias FillColor =
  Color


view : PixelsAcross -> BorderColor -> FillColor -> Graphics.Element.Element
view pixelsAcross borderColor fillColor =
  let
    pixels =
      toFloat pixelsAcross

    outline =
      square pixels
        |> outlined (solid borderColor)

    fill =
      square pixels
        |> filled fillColor
  in
    collage pixelsAcross pixelsAcross [ fill, outline ]
