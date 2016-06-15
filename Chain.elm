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


keyDown : KeyCode -> Model -> Model
keyDown keyCode model =
    case Key.fromCode keyCode of
        ArrowLeft ->
            updateLoc ( -1, 0 ) model

        ArrowUp ->
            updateLoc ( 0, -1 ) model

        ArrowRight ->
            updateLoc ( 1, 0 ) model

        ArrowDown ->
            updateLoc ( 0, 1 ) model

        Unknown ->
            model


updateLoc : Location -> Model -> Model
updateLoc delta chain =
  let
    ( dx, dy ) =
      delta

    headPiece = List.head chain

    updatedChain =
      case headPiece of
        Just headPiece ->

          ( x, y ) =
            headPiece.location

          newLocation =
            ( x +  dx, y + dy )

          changedPiece =
            { headPiece | location = newLocation }

          tailChain = List.tail chain

          case tailChain of

            Just tailChain ->

              (changedPiece :: tailChain)

            Nothing ->

              chain

      Nothing ->
        chain
  in
    uupdatedChain


-- Note that we are not rendering a view;
-- letting Piece handle.
