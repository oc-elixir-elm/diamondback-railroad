module Chain
    exposing
        ( Model
        , init
        , update
        , subscriptions
        , sameLocation
        , Msg(KeyDown)
        )

import Html exposing (Html)
import Piece exposing (Msg(..))
import Keyboard exposing (KeyCode)
import Key exposing (..)
import Matrix exposing (Location)
import Debug exposing (log)
import Time exposing (Time)


type alias Model =
    List Piece.Model


init : ( Model, Cmd Msg )
init =
    ( [], Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyDown
        ]


type Msg
    = KeyDown KeyCode
    | Resize Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        updatedModel =
            case msg of
                KeyDown keyCode ->
                    keyDown keyCode model

                Resize sideSize ->
                    resizePieces model sideSize
    in
        ( updatedModel, Cmd.none )


keyDown : KeyCode -> Model -> Model
keyDown keyCode chain =
    case Key.fromCode keyCode of
        ArrowLeft ->
            moveChainStartingAtHead ( -1, 0 ) chain

        ArrowUp ->
            moveChainStartingAtHead ( 0, -1 ) chain

        ArrowRight ->
            moveChainStartingAtHead ( 1, 0 ) chain

        ArrowDown ->
            moveChainStartingAtHead ( 0, 1 ) chain

        Unknown ->
            chain


resizePieces : Model -> Float -> Model
resizePieces model sideSize =
    List.map (\piece -> resizePiece piece sideSize) model


resizePiece : Piece.Model -> Float -> Piece.Model
resizePiece piece sideSize =
    let
        pieceMsg =
            Piece.Resize sideSize

        (updatedPiece, _) =
            Piece.update piece pieceMsg
    in
        updatedPiece

{-| This is the command to "pull" the pieces in a
chain around.  The headDelta value indicates one
displacement either vertically (y) or horizontally (x).
This is applied to the head piece of the chain.

The next piece is then moved to where the head was,
and this process (moveChain) recursively occurs
until all pieces in the chain have moved.

This has been tested down to a chain having only one piece.

This will move the head piece if

  1.  It doesn't move off the board.
  2.  It doesn't move into another piece
-}
moveChainStartingAtHead : Location -> Model -> Model
moveChainStartingAtHead headDelta chain =
    case (List.head chain) of
        Nothing ->
            chain

        Just firstPiece ->
            let
                proposedLocation =
                    newLocation headDelta firstPiece.location
            in
                if
                    illegalMove proposedLocation
                        chain
                then
                    chain
                else
                    case (List.tail chain) of
                        Nothing ->
                            chain

                        Just tailChain ->
                            moveChain headDelta
                                firstPiece
                                tailChain
                                []


illegalMove : Location -> Model -> Bool
illegalMove proposedLocation chain =
    (illegalMoveOffBoard proposedLocation)
        || (illegalCollideWithPiece proposedLocation
                chain
           )


illegalMoveOffBoard : Location -> Bool
illegalMoveOffBoard proposedLocation =
    let
        ( testX, testY ) =
            proposedLocation
    in
        (testX < 0)
            || (testY < 0)
            || (testX >= 11)
            || (testY >= 11)


illegalCollideWithPiece : Location -> Model -> Bool
illegalCollideWithPiece proposedLocation chain =
    case List.tail chain of
        Nothing ->
            False

        Just tailChain ->
            List.any
                (\piece ->
                    collideWithPiece proposedLocation
                        piece
                )
                tailChain


collideWithPiece : Location -> Piece.Model -> Bool
collideWithPiece proposedLocation piece =
    let
        ( nx, ny ) =
            proposedLocation

        ( px, py ) =
            piece.location
    in
        (nx == px) && (ny == py)


newLocation : Location -> Location -> Location
newLocation delta headLocation =
    let
        ( x, y ) =
            headLocation

        ( dx, dy ) =
            delta
    in
        ( x + dx, y + dy )


sameLocation : Location -> Location -> Bool
sameLocation oldLocation newLocation =
    let
        ( oldX, oldY ) =
            oldLocation

        ( newX, newY ) =
            newLocation
    in
        (oldX == newX) && (oldY == newY)


moveChain :
    Location
    -> Piece.Model
    -> List Piece.Model
    -> List Piece.Model
    -> Model
moveChain delta headPiece tailChain doneChain =
    moveCurrentPiece headPiece delta doneChain
        |> moveNextPiece tailChain headPiece


moveCurrentPiece :
    Piece.Model
    -> Location
    -> Model
    -> Model
moveCurrentPiece piece delta doneChain =
    let
        updatedPiece =
            changeLocForPiece delta
                piece
    in
        updatedPiece :: doneChain


moveNextPiece :
    List Piece.Model
    -> Piece.Model
    -> Model
    -> Model
moveNextPiece tailChain headPiece doneChain =
    case (List.head tailChain) of
        Nothing ->
            List.reverse doneChain

        Just nextPiece ->
            let
                delta =
                    calculateDelta nextPiece.location
                        headPiece.location
            in
                case (List.tail tailChain) of
                    Nothing ->
                        List.reverse doneChain

                    Just remnantChain ->
                        moveChain delta
                            nextPiece
                            remnantChain
                            doneChain


calculateDelta : Location -> Location -> Location
calculateDelta thisLocation nextLocation =
    let
        ( thisX, thisY ) =
            thisLocation

        ( nextX, nextY ) =
            nextLocation

        dx =
            nextX - thisX

        dy =
            nextY - thisY
    in
        ( dx, dy )


changeLocForPiece : Location -> Piece.Model -> Piece.Model
changeLocForPiece delta piece =
    let
        msg =
            Move delta

        ( changedPiece, _ ) =
            Piece.update msg piece
    in
        changedPiece



{-
   renderPiece : Piece.Model -> Html Msg
   renderPiece piece =
       Html.App.map (ModifyPiece piece.location)


   view : Model -> Html Msg
   view model =
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
               (List.map renderPiece model)
           ]
-}
