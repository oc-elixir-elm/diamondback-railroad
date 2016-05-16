module Position exposing (view)

import Html exposing (..)
import Html.App as Html
import Svg exposing (..)
import Svg.Attributes exposing (..)
import PositionType exposing (..)
import Color exposing (..)
import Matrix exposing (Location, loc)
import Time exposing (Time, second)


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


type alias Model =
  ( PositionType, Location )


init : ( Model, Cmd Msg )
init =
  (( PositionType.assignGrid, loc 1 1 ), Cmd.none)


-- UPDATE


type Msg
  = Tick Time


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (model, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick


-- VIEW

view : Model -> Html Msg
view model =
  Html.text "Hello, World"


{-

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

-}
