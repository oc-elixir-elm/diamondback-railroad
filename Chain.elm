module Chain exposing (Model, init, view, update, subscriptions)

import Html exposing (Html)
import Piece exposing (Msg, PieceNumber)
import AnimationFrame
import Time exposing (Time)


type alias Model =
    List Piece.Model


init : ( Model, Cmd Msg )
init =
    ( [], Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    AnimationFrame.times Animate


type Msg
    = Show
    | Animate Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( pieceNumber, x, y ) =
            tuple

        ( piece, _ ) =
            Piece.initWithInfo pieceNumber sideSize ( x, y )
    in
        piece


view : Model -> Html Msg
view model =
    Html.text "chain"
