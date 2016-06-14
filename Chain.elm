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
    = Show
    | Animate Time
    | KeyDown KeyCode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        result =
            case msg of
                KeyDown keyCode ->
                    keyDown keyCode model

                Show ->
                    model

                Animate time ->
                    model
    in
        ( result, Cmd.none )


keyDown : KeyCode -> model -> model
keyDown keyCode model =
    case Key.fromCode keyCode of
        ArrowLeft ->
            model

        ArrowUp ->
            model

        ArrowRight ->
            model

        ArrowDown ->
            model

        Unknown ->
            model



-- Note that we are not rendering a view;
-- letting Piece handle.
