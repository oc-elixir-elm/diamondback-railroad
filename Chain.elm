module Chain
    exposing
        ( Model
        , init
        , update
        , subscriptions
        , Msg(KeyDown)
        )

import Html exposing (Html)
import Html.App
import Piece exposing (Msg(..))
import AnimationFrame
import Time exposing (Time)
import Style
import Keyboard exposing (KeyCode)
import Key exposing (..)
import Matrix exposing (Location)
import Debug exposing (log)


type alias Model =
    List Piece.Model


init : ( Model, Cmd Msg )
init =
    ( [], Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.times Animate
        , Keyboard.downs KeyDown
        ]


type Msg
    = Animate Time
    | KeyDown KeyCode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        updatedModel =
            case msg of
                KeyDown keyCode ->
                    keyDown keyCode model

                Animate time ->
                    model
    in
        ( updatedModel, Cmd.none )


keyDown : KeyCode -> Model -> Model
keyDown keyCode chain =
    let
        directionKey =
            Key.fromCode keyCode
    in
        case directionKey of
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


moveChainStartingAtHead : Location -> Model -> Model
moveChainStartingAtHead startingDelta chain =
    case (List.head chain) of
        Nothing ->
            chain

        Just firstPiece ->
            case (List.tail chain) of
                Nothing ->
                    chain

                Just tailChain ->
                    let
                        newLocation =
                            calculateNewLoc firstPiece startingDelta
                    in
                        moveChain newLocation
                            firstPiece
                            tailChain
                            []


calculateNewLoc : Piece.Model -> Location -> Location
calculateNewLoc piece delta =
    let
        ( oldX, oldY ) =
            piece.location

        ( dX, dY ) =
            delta
    in
        ( oldX + dX, oldY + dY )


moveChain :
    Location
    -> Piece.Model
    -> List Piece.Model
    -> List Piece.Model
    -> Model
moveChain newLocation headPiece tailChain doneChain =
    let
        delta =
            calculateDelta headPiece.location
                newLocation

        updatedPiece =
            changeLocForPiece delta
                headPiece

        doneChain =
            updatedPiece :: doneChain
    in
        case (List.head tailChain) of
            Nothing ->
                List.reverse doneChain

            Just nextPiece ->
                let
                    nextLocation =
                        headPiece.location
                in
                    case (List.tail tailChain) of
                        Nothing ->
                            List.reverse doneChain

                        Just remnantChain ->
                            moveChain nextLocation
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
        log "delta" ( dx, dy )


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
