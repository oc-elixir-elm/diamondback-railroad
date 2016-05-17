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


pixelsAcross =
  100



-- MODEL


type alias Model =
  ( PositionType, Location )


init : ( Model, Cmd Msg )
init =
  ( ( PositionType.assignGrid, loc 1 1 ), Cmd.none )



-- UPDATE


type Msg
  = Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Tick newTime ->
      ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick



-- VIEW


view : Model -> Html Msg
view model =
  let
    polys =
      polygon [ fill "#F0AD00", points "50 0, 100 50, 50 100, 0 50" ] []
  in
    Svg.svg
      [ version "1.1"
      , x "0"
      , y "0"
      , viewBox "0 0 100 100"
      ]
      [ polys
      ]
