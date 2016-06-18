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
moveChainStartingAtHead delta chain =
    let
        doneChain =
            moveChain delta
                (List.head chain)
                (List.tail chain)
    in
        doneChain


moveChain :
    Location
    -> Maybe Piece.Model
    -> Maybe (List Piece.Model)
    -> Model
moveChain delta headPiece tailChain =
    case headPiece of
        Nothing ->
            []

        Just headPiece ->
            case tailChain of
                Nothing ->
                    []

                Just tailChain ->
                    changeLocForPiece delta headPiece tailChain


changeLocForPiece : Location -> Piece.Model -> Model -> Model
changeLocForPiece delta headPiece tailChain =
    let
        msg =
            Move delta

        ( changedPiece, _ ) =
            Piece.update msg headPiece
    in
        changedPiece :: tailChain



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
