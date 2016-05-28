module Board exposing (init, view, update, subscriptions)

-- import Effects exposing (Effects)
-- import Graphics.Element exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


-- import Html.Events exposing (onClick)

import Position
import Matrix exposing (Matrix)
import Maybe exposing (..)
import Color exposing (Color, lightBrown, darkBrown)
import Time exposing (Time, second)


-- MODEL


type alias PosCount =
  Int


maxPosLength : PosCount
maxPosLength =
  11


positionFromInit : Matrix.Location -> Position.Model
positionFromInit location =
  let
    ( position, msg ) =
      Position.init location
  in
    position


createMatrix : PosCount -> Matrix Position.Model
createMatrix posCount =
  Matrix.square posCount (\location -> positionFromInit location)


type alias Model =
  { board : Matrix Position.Model }


init : ( Model, Cmd Msg )
init =
  ( { board = createMatrix maxPosLength }, Cmd.none )



-- UPDATE


type Msg
  = Tick Time


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (model, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick



-- VIEW
-- Number of positions on the side of the boafd


type alias BoardSideInPixels =
  Int


type alias Width =
  Int


type alias Height =
  Int


type alias Dimensions =
  ( Width, Height )


borderColor : Color
borderColor =
  darkBrown


fillColor : Color
fillColor =
  lightBrown


borderThickness : Int
borderThickness =
  10


render_rows =
  [ text " square"
  ]


view : Model -> Html Msg
view model =
  text "Hello"
