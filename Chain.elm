module Chain
    exposing
        ( Model
        , init
        , update
        , subscriptions
        )

import Html exposing (Html)
import Piece
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
                    keyDown (log "keycode" keyCode) model

                Animate time ->
                    model
    in
        ( updatedModel, Cmd.none )


keyDown : KeyCode -> Model -> Model
keyDown keyCode chain =
    case Key.fromCode keyCode of
        ArrowLeft ->
            updateLoc ( -1, 0 ) chain

        ArrowUp ->
            updateLoc ( 0, -1 ) chain

        ArrowRight ->
            updateLoc ( 1, 0 ) chain

        ArrowDown ->
            updateLoc ( 0, 1 ) chain

        Unknown ->
            chain


updateLoc : Location -> Model -> Model
updateLoc delta chain =
    updateLocForHead delta (List.head chain) chain


updateLocForHead : Location -> Maybe Piece.Model -> Model -> Model
updateLocForHead delta headPiece chain =
    case headPiece of
        Nothing ->
            chain

        Just headPiece ->
            case List.tail chain of
                Nothing ->
                    chain

                Just tailChain ->
                    changeLocForHead delta headPiece chain


changeLocForHead : Location -> Piece.Model -> Model -> Model
changeLocForHead delta headPiece tailChain =
    let
        ( dx, dy ) =
            delta

        ( x, y ) =
            headPiece.location

        newLocation =
            ( x + dx, y + dy )

        changedPiece =
            { headPiece | location = newLocation }

        updatedChain =
            (changedPiece :: tailChain)
    in
        updatedChain



-- Note that we are not rendering a view;
-- letting Piece handle.
