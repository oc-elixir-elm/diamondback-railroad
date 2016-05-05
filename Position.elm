module Position  where

import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Color exposing (..)
import Html exposing (..)

type alias PixelsAcross = Int
type alias BorderColor = Color
type alias FillColor = Color

type alias Model =
  { borderColor : BorderColor
  , fillColor : FillColor
  , pixels : PixelsAcross
  }

init : PixelsAcross -> BorderColor -> FillColor -> Model
init pixelsSize borderColor fillColor =
  { pixels = pixelsSize
  , borderColor = borderColor
  , fillColor = fillColor
  }


type Action = Nothing

update : Action -> Model -> Model
update action model =
  model

-- TODO: All you should need is the view here.
-- Simply pass it the border color, fill color, and
-- number of pixels across.  Then adjust the caller
-- to simply have the view feed to main.
view : Signal.Address Action -> Model -> Html
view address model =
  let
    pixels = model.pixels
    outline =
      square pixels
        |> outlined (solid model.borderColor)
    fill =
      square pixels
        |> filled model.fillColor
  in
    collage pixels pixels [fill, outline]
      |> Html.fromElement
