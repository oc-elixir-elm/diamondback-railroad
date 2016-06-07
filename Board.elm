module Board exposing (init, view, update, subscriptions)

-- import Effects exposing (Effects)

import Html exposing (Html)
import Html.App


-- import Html.Attributes exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)


-- import Html.Events exposing (onClick)

import Matrix exposing (Matrix)
import Position
import Piece
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


positionFromInit : Matrix.Location -> Position.Model
positionFromInit location =
    let
        ( position, msg ) =
            Position.initWithInfo (squareType location)
                maxPosLength
                sideSize
                location
    in
        position


createMatrix : PosCount -> Matrix Position.Model
createMatrix posCount =
    Matrix.square posCount (\location -> positionFromInit location)


type alias Model =
    { board : Matrix Position.Model, pieces : List Piece.Model }


type alias PositionLocator =
    { location : Matrix.Location
    , model : Position.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        ( piece, _ ) =
            Piece.init
    in
        ( { board = createMatrix maxPosLength, pieces = [ piece ] }, Cmd.none )



-- UPDATE


type Msg
    = Tick Time
    | ModifyPosition Matrix.Location Position.Msg
    | ModifyPiece Matrix.Location Piece.Msg


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
    Html.App.map (ModifyPosition position.location) (Position.view position)


renderPiece : Piece.Model -> Html Msg
renderPiece piece =
    Html.App.map (ModifyPiece piece.location) (Piece.view piece)


view : Model -> Html Msg
view model =
    let
        positions =
            Matrix.flatten model.board

        pieces =
            model.pieces
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
            , svg []
                (List.map renderPiece pieces)
            ]
