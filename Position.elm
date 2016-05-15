module Position exposing (view)

import Html exposing (..)
import Html.App as Html
import Svg exposing (..)
import Svg.Attributes exposing (..)
import PositionType
import Color exposing (..)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


type alias PixelsAcross =
  Int


type alias BorderColor =
  Color


type alias FillColor =
  Color

-- MODEL

type alias Model = (PositionType, Location)


-- UPDATE

type Msg = Reset

update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset ->
      model


-- VIEW

view : Model -> Html Msg
view model =

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
