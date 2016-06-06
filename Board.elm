module Board exposing (init, view, update, subscriptions)

-- import Effects exposing (Effects)

import Html exposing (Html)
import Html.App


-- import Html.Attributes exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)


-- import Html.Events exposing (onClick)

import Position
import Matrix exposing (Matrix)
import Maybe exposing (..)


-- import Maybe exposing (..)

import Color exposing (Color, lightBrown, darkBrown)
import Time exposing (Time, second)
import Window


-- MODEL


type alias PosCount =
    Int


maxPosLength : PosCount
maxPosLength =
    11


type alias BoardSideInPixels =
    Int


boardSideInPixels : BoardSideInPixels
boardSideInPixels =
    400


sideSize =
    (toFloat boardSideInPixels) / (toFloat maxPosLength)


squareType : Matrix.Location -> Position.PositionType
squareType location =
    let
        ( x, y ) =
            location

        maxPos =
            maxPosLength - 1
    in
        if (x == 0) || (x == maxPos) || (y == 0) || (y == maxPos) then
            Position.Perimeter
        else
            Position.Grid


calculatedPieceNumber : Matrix.Location -> Position.PieceNumber
calculatedPieceNumber location =
    let
        ( x, y ) =
            location
    in
        1 + x + (maxPosLength * y)


positionFromInit : Matrix.Location -> Position.Model
positionFromInit location =
    let
        ( position, msg ) =
            Position.initWithInfo (squareType location)
                maxPosLength
                sideSize
                location
                (calculatedPieceNumber location)
    in
        position


createMatrix : PosCount -> Matrix Position.Model
createMatrix posCount =
    Matrix.square posCount (\location -> positionFromInit location)


type alias Model =
    { board : Matrix Position.Model }


type alias PositionLocator =
    { location : Matrix.Location
    , model : Position.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { board = createMatrix maxPosLength }, Cmd.none )



-- UPDATE


type Msg
    = Tick Time
    | Modify Matrix.Location Position.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick



-- VIEW
-- Number of positions on the side of the boafd


type alias Width =
    Int


type alias Height =
    Int


type alias Dimensions =
    ( Width, Height )


dimensions : Dimensions
dimensions =
    ( 1200, 700 )


borderColor : Color
borderColor =
    darkBrown


fillColor : Color
fillColor =
    lightBrown


borderThickness : Int
borderThickness =
    10


renderPosition : Position.Model -> Html Msg
renderPosition position =
    Html.App.map (Modify position.location) (Position.view position)


view : Model -> Html Msg
view model =
    let
        positions =
            Matrix.flatten model.board
    in
        svg
            [ width "600"
            , height "600"
            ]
            [ rect
                [ stroke "blue"
                , fill "white"
                , width "600"
                , height "600"
                ]
                []
            , svg []
                (List.map renderPosition positions)
            ]
