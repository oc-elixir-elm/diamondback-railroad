module Board
    exposing
        ( init
        , view
        , update
        , subscriptions
        )

-- import Effects exposing (Effects)

import Html exposing (Html, div)
import Html.App


-- import Html.Attributes exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)


-- import Html.Events exposing (onClick)

import Matrix exposing (Matrix, Location)
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


squareType : Location -> Position.PositionType
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


positionFromInit : Location -> Position.Model
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
    , moveCount : Int
    }


type alias PositionLocator =
    { location : Location
    , model : Position.Model
    }


create81Pieces : List Piece.Model
create81Pieces =
    List.map (\pos -> createPieceForPos pos) [0..80]


createPieceForPos : Int -> Piece.Model
createPieceForPos position =
    let
        x =
            xForPos position

        y =
            yForPos position

        tuple =
            ( position + 1, x, y )
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


init : ( Model, Cmd Msg )
init =
    let
        board =
            createMatrix maxPosLength

        pieces =
            create81Pieces

        -- one chain includes all the pieces
        chain =
            pieces

        moveCount =
            0
    in
        ( { board = board
          , pieces = pieces
          , chain = chain
          , moveCount = moveCount
          }
        , Cmd.none
        )



-- UPDATE


type Msg
    = ModifyPosition Location Position.Msg
    | ModifyPiece Location Piece.Msg
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

                oldChain = model.chain

                ( newChain, _ ) =
                    Chain.update chainMsg oldChain

                updatedModelForChain =
                    { model
                        | chain = newChain
                    }

                ( newMoveCount, newLocation ) =
                    updateMoveCount updatedModelForChain oldChain

                dummy =
                  newLocation
            in
                case newLocation of
                    Nothing ->
                        ( updatedModelForChain, Cmd.none )

                    Just newLocation ->
                        let
                            updatedBoard =
                                addTraversal newLocation
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
updateMoveCount model newChain =
    case List.head newChain of
        Nothing ->
            noMove (model)

        Just newPiece ->
            case List.head model.chain of
                Nothing ->
                    noMove (model)

                Just oldPiece ->
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


addTraversal :
    Location
    -> Matrix Position.Model
    -> Matrix Position.Model
addTraversal location board =
    case Matrix.get location board of
        Nothing ->
            board

        Just position ->
            let
                ( newPosition, _ ) =
                    Position.update Position.MarkTraversal
                        position
            in
                Matrix.set newPosition.location
                    newPosition
                    board



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


renderMoveCount : Int -> String
renderMoveCount moveCount =
    "Moves thus far: " ++ (toString moveCount)


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
        div []
            [ svg
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
            , div []
                [ text (renderMoveCount model.moveCount)
                ]
            ]
