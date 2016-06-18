module Board
    exposing
        ( init
        , view
        , update
        , subscriptions
        )

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
import Chain
import Maybe exposing (..)
import Color exposing (Color, lightBrown, darkBrown)
import Time exposing (Time, second)
import Window
import Keyboard exposing (KeyCode)
import Debug exposing (log)


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
    (toFloat boardSideInPixels)
        / (toFloat maxPosLength)


squareType : Matrix.Location -> Position.PositionType
squareType location =
    let
        ( x, y ) =
            location

        maxPos =
            maxPosLength - 1
    in
        if
            (x == 0)
                || (x == maxPos)
                || (y == 0)
                || (y == maxPos)
        then
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
    Matrix.square posCount
        (\location -> positionFromInit location)


type alias Model =
    { board : Matrix Position.Model
    , pieces : List Piece.Model
    , chain : Chain.Model
    }


type alias PositionLocator =
    { location : Matrix.Location
    , model : Position.Model
    }


piecesInfo =
    [ ( 47, 2, 2 )
    , ( 48, 3, 2 )
    , ( 49, 3, 3 )
    , ( 4, 8, 6 )
    , ( 5, 9, 9 )
    ]


initPiece : ( Int, Int, Int ) -> Piece.Model
initPiece tuple =
    let
        ( pieceNumber, x, y ) =
            tuple

        ( piece, _ ) =
            Piece.initWithInfo pieceNumber
                sideSize
                ( x, y )
    in
        piece


initChain : List Piece.Model -> Chain.Model
initChain pieces =
    List.take 3 pieces


init : ( Model, Cmd Msg )
init =
    let
        board =
            createMatrix maxPosLength

        pieces =
            List.map (\pieceInfo -> (initPiece pieceInfo))
                piecesInfo

        chain =
            initChain pieces
    in
        ( { board = board
          , pieces = pieces
          , chain = chain
          }
        , Cmd.none
        )



-- UPDATE


type Msg
    = ModifyPosition Matrix.Location Position.Msg
    | ModifyPiece Matrix.Location Piece.Msg
    | KeyDown KeyCode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ModifyPosition location positionMsg ->
            ( model, Cmd.none )

        ModifyPiece location pieceMsg ->
            ( model, Cmd.none )

        KeyDown keyCode ->
            let
                chainMsg =
                    Chain.KeyDown keyCode

                logChain =
                    model.chain

--                logHeadPiece =
--                    log "head" (List.head logChain)

                ( chain, _ ) =
                    Chain.update chainMsg model.chain

                updatedModel =
                    { model | chain = chain }
            in
                ( updatedModel, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyDown
        ]



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
    Html.App.map (ModifyPosition position.location)
        (Position.view position)


renderPiece : Piece.Model -> Html Msg
renderPiece piece =
    Html.App.map (ModifyPiece piece.location)
        (Piece.view piece)


view : Model -> Html Msg
view model =
    let
        positions =
            Matrix.flatten model.board

        pieces =
            model.pieces

        chain =
            model.chain
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
              -- , svg []
              --     (List.map renderPiece pieces)
            , svg []
                (List.map renderPiece chain)
            ]
