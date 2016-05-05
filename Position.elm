module Position  where

import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Color exposing (..)
import Html exposing (..)

type Role = Grid | Perimeter

type alias X = Int
type alias Y = Int
type alias PixelsAcross = Int

type alias Model =
  { role : Role
  , pixelsAcross : PixelsAcross
  , x : X
  , y : Y
  }

pixelsAcross = 50

init : Model
init =
  { role = Grid
  , pixelsAcross = pixelsAcross
  , x = 0
  , y = 0
  }


type Action = UpdateGrid | UpdatePerimeter


update : Action -> Model -> Model
update action  model =
  case action of
    UpdateGrid ->
      { model | role = Grid }

    UpdatePerimeter ->
      { model | role = Perimeter }

{-
createGrid : X -> Y -> Model
createGrid x y =
  init
  |> .x x
  |> .y y


createPerimeter : X -> Y -> Model
createPermiter x y =
  createGrid
    |> .role Perimeter
-}


view : Signal.Address Action -> Model -> Html
view address model =
  let
    outline =
      square pixelsAcross
        |> outlined (solid darkBrown)
    fill =
      square pixelsAcross
        |> filled lightBrown
  in
    collage pixelsAcross pixelsAcross [fill, outline]
      |> Html.fromElement
