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


pixelsAcross = 100


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
  Svg.svg
    [ version "1.1", x "0", y "0", viewBox "0 0 323.141 322.95"
    ]
    [ polygon [ fill "#F0AD00", points "161.649,152.782 231.514,82.916 91.783,82.916" ] []
    , polygon [ fill "#7FD13B", points "8.867,0 79.241,70.375 232.213,70.375 161.838,0" ] []
    , rect
        [ fill "#7FD13B", x "192.99", y "107.392", width "107.676", height "108.167"
        , transform "matrix(0.7071 0.7071 -0.7071 0.7071 186.4727 -127.2386)"
        ]
        []
    , polygon [ fill "#60B5CC", points "323.298,143.724 323.298,0 179.573,0" ] []
    , polygon [ fill "#5A6378", points "152.781,161.649 0,8.868 0,314.432" ] []
    , polygon [ fill "#F0AD00", points "255.522,246.655 323.298,314.432 323.298,178.879" ] []
    , polygon [ fill "#60B5CC", points "161.649,170.517 8.869,323.298 314.43,323.298" ] []
    ]
