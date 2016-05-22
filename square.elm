module Main exposing (view, model)

import Html exposing (Html, button, div, text, input, h2)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onInput)
import Html.App as Html
import Svg exposing (..)
import Svg.Attributes exposing (..)
import String exposing (toInt)


main : Program Never
main =
    Html.beginnerProgram { model = model, view = testView, update = update }



-- MODEL


type alias Size =
    String


type alias Position =
    String


type alias Model =
    { locationX : Position
    , locationY : Position
    , size : Size
    }


model : Model
model =
    { locationX = "0"
    , locationY = "0"
    , size = "50"
    }



-- UPDATE


type Msg
    = Resize Size
    | ShiftX Position
    | ShiftY Position


update : Msg -> Model -> Model
update msg model =
    case msg of
        Resize size ->
            { model | size = size }

        ShiftX position ->
            { model | locationX = position }

        ShiftY position ->
            { model | locationY = position }



-- VIEW


testView : Model -> Html Msg
testView model =
    div [ Html.Attributes.style[("border", "solid")]]
        [ viewPort model
        , h2 [] [ Html.text "size" ]
        , input [ placeholder model.size, onInput Resize ] []
        , h2 [] [ Html.text "column" ]
        , input [ placeholder model.locationX, onInput ShiftX ] []
        , h2 [] [ Html.text "row" ]
        , input [ placeholder model.locationY, onInput ShiftY ] []
        ]


viewPort : Model -> Html.Html msg
viewPort model =
    svg [ width "400", height "400" ]
        [ rect
            [ stroke "blue"
            , fill "white"
            , width "400"
            , height "400"
            ]
            []
        , mySquare model
        ]


view : Model -> Svg Msg
view model =
    mySquare model


mySquare : Model -> Svg a
mySquare model =
    rect
        [ stroke "brown"
        , fill "beige"
        , x (shiftX model)
        , y (shiftY model)
        , width model.size
        , height model.size
        , rx "4"
        , ry "4"
        ]
        []


shiftX : Model -> String
shiftX model =
    let
        x =
            Result.withDefault 0 (String.toInt model.locationX)

        size =
            Result.withDefault 0 (String.toInt model.size)
    in
        toString (x * size)


shiftY : Model -> String
shiftY model =
    let
        y =
            Result.withDefault 0 (String.toInt model.locationY)

        size =
            Result.withDefault 0 (String.toInt model.size)
    in
        toString (y * size)
