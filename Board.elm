module Board
    exposing
        ( Model
        , init
        , view
        , update
        , subscriptions
        )

import Html exposing (Html, div)


-- import Html.Attributes exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Animation


-- import Html.Events exposing (onClick)

import Matrix exposing (Matrix, Location)
import Position
import Piece
import Chain exposing (Msg(..))
import Maybe exposing (..)
import Color exposing (Color, lightBrown, darkBrown)
import Time exposing (Time, second)
import Window
import Keyboard exposing (KeyCode)
import Task
import Debug exposing (log)


-- MODEL


type alias PosCount =
    Int


type alias SideSize =
    Float


squareType : Location -> PosCount -> Position.PositionType
squareType location maxPosLength =
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


positionFromInit : Location -> PosCount -> SideSize -> Position.Model
positionFromInit location maxPosLength sideSize =
    let
        ( position, msg ) =
            Position.initWithInfo (squareType location maxPosLength)
                maxPosLength
                sideSize
                location
    in
        position


createMatrix : PosCount -> SideSize -> Matrix Position.Model
createMatrix maxPosLength sideSize =
    Matrix.square maxPosLength
        (\location ->
            positionFromInit location
                maxPosLength
                sideSize
        )


type alias Model =
    { board : Matrix Position.Model
    , chain : Chain.Model
    , moveCount : Int
    , blinkState : Bool
    , maxPosLength : PosCount
    , sideSize : SideSize
    }


type alias PositionLocator =
    { location : Location
    , model : Position.Model
    }


{-|
   For debugging animation, keep only one piece
   instead of 81.
-}
create81Pieces : Float -> List Piece.Model
create81Pieces sideSize =
    List.map (\pos -> createPieceForPos pos sideSize) (List.range 0 0)


--80


createPieceForPos : Int -> Float -> Piece.Model
createPieceForPos position sideSize =
    let
        x =
            xForPos position

        y =
            yForPos position

        tuple =
            ( position + 1, x, y, sideSize )
    in
        initPiece tuple


xForPos : Int -> Int
xForPos position =
    let
        roundTrip =
            position % 18

        leftToRight =
            position % 9

        rightToLeft =
            8 - (position % 9)

        twoRows =
            roundTrip // 9
    in
        case twoRows of
            0 ->
                1 + leftToRight

            1 ->
                1 + rightToLeft

            _ ->
                1


yForPos : Int -> Int
yForPos position =
    1 + (position // 9)


initPiece : ( Int, Int, Int, Float ) -> Piece.Model
initPiece tuple =
    let
        ( pieceNumber, x, y, sideSize) =
            tuple

        ( piece, _ ) =
            Piece.initWithInfo pieceNumber
                sideSize
                ( x, y )

    in
        piece


init : ( Model, Cmd Msg )
init =
    let
        maxPosLength =
            11

        sideSize =
            boardSide
                / (toFloat maxPosLength)
    in
        ( { moveCount = 0
          , blinkState = False
          , maxPosLength = maxPosLength
          , sideSize = sideSize
          , board =
                createMatrix
                    maxPosLength
                    sideSize
          , chain = create81Pieces sideSize
          }
--        , Task.perform BoardResize Window.size
        , Cmd.none
        )


initFromPosCount : PosCount -> ( Model, Cmd Msg )
initFromPosCount posCount =
    let
        ( model, msg ) =
            init

        newModel =
            { model
                | maxPosLength = posCount
            }
    in
        ( newModel, msg )



-- UPDATE


type Msg
    = ModifyPosition Location Position.Msg
    | ModifyPiece Location Piece.Msg
    | KeyDown KeyCode
    | Blink Time
    | Animate Animation.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ModifyPosition location positionMsg ->
            ( model, Cmd.none )

        ModifyPiece location pieceMsg ->
            ( model, Cmd.none )

        KeyDown keyCode ->
            manageKeyDown model keyCode

        Blink time ->
            blinkUnvisitedPerimeterPositions model

        Animate chain ->
            --            Chain.update Animate chain
            ( model, Cmd.none )


manageKeyDown : Model -> KeyCode -> ( Model, Cmd Msg )
manageKeyDown model keyCode =
    let
        chainMsg =
            Chain.KeyDown keyCode

        oldChain =
            model.chain

        ( newChain, _ ) =
            Chain.update chainMsg oldChain

        updatedModelForChain =
            { model
                | chain = newChain
            }

        ( newMoveCount, newLocation ) =
            updateMoveCount updatedModelForChain oldChain
    in
        case newLocation of
            Nothing ->
                ( updatedModelForChain, Cmd.none )

            Just newLocation ->
                let
                    updatedBoard =
                        addVisited newLocation
                            model.board

                    updatedModel =
                        { updatedModelForChain
                            | moveCount =
                                newMoveCount
                            , board =
                                updatedBoard
                        }
                in
                    ( updatedModel, Cmd.none )


updateMoveCount : Model -> List Piece.Model -> ( Int, Maybe Location )
updateMoveCount model oldChain =
    case List.head oldChain of
        Nothing ->
            noMove (model)

        Just oldPiece ->
            case List.head model.chain of
                Nothing ->
                    noMove (model)

                Just newPiece ->
                    if
                        Chain.sameLocation newPiece.location
                            oldPiece.location
                    then
                        noMove (model)
                    else
                        ( 1 + model.moveCount, Just newPiece.location )


noMove : Model -> ( Int, Maybe Location )
noMove model =
    ( model.moveCount, Nothing )


addVisited :
    Location
    -> Matrix Position.Model
    -> Matrix Position.Model
addVisited location board =
    case Matrix.get location board of
        Nothing ->
            board

        Just position ->
            let
                ( newPosition, _ ) =
                    Position.update Position.MarkVisited
                        position
            in
                Matrix.set newPosition.location
                    newPosition
                    board


blinkUnvisitedPerimeterPositions : Model -> ( Model, Cmd Msg )
blinkUnvisitedPerimeterPositions model =
    let
        newBlinkState =
            not model.blinkState

        newBoard =
            blinkPerimeterPositions newBlinkState model.board

        newModel =
            { model
                | blinkState = newBlinkState
                , board = newBoard
            }
    in
        ( newModel, Cmd.none )


blinkPerimeterPositions :
    Bool
    -> Matrix Position.Model
    -> Matrix Position.Model
blinkPerimeterPositions newBlinkState board =
    Matrix.map
        (\position ->
            blinkPosition newBlinkState position
        )
        board


blinkPosition : Bool -> Position.Model -> Position.Model
blinkPosition newBlinkState position =
    if Position.isPerimeter position then
        Position.blink newBlinkState
            position
    else
        position


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyDown
--        , Time.every (700 * Time.millisecond) Blink
        , Animation.subscription
            Animate
            (listAnimationState model)
        ]



-- Figuring out what Animate argument needs to be
listAnimationState : Model -> List Animation.State
listAnimationState model =
    List.map .style model.chain


-- VIEW


boardSide : Float
boardSide =
    1.0


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
    Html.map (ModifyPosition position.location)
        (Position.view position)


renderPiece : Piece.Model -> Html Msg
renderPiece piece =
    Html.map (ModifyPiece piece.location)
        (Piece.view piece)


renderMoveCount : Int -> String
renderMoveCount moveCount =
    "Moves thus far: " ++ (toString moveCount)


view : Model -> Html Msg
view model =
    let
        positions =
            Matrix.flatten model.board

        chain =
            model.chain
    in
        svg
            [ version "1.1"
            , width "100%"
            , height "100%"
            , viewBox "0 0 1 1"
            , preserveAspectRatio "xMidYMid meet"
            ]
--            [ svg []
--                (List.map renderPosition positions)
--            , svg []
--                (List.map renderPiece chain)
--            ]
            [ svg []
                (List.map renderPiece chain)
            ]
