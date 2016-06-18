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
                    changeLocForHead delta headPiece tailChain


changeLocForHead : Location -> Piece.Model -> Model -> Model
changeLocForHead delta headPiece tailChain =
    let
        msg = Move delta
        (changedPiece, _) =
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
