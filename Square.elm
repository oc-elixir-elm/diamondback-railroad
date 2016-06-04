module Square exposing (view, model, square, init)

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


type alias XY =
    Int


type alias Pixels =
    Int


type alias Model =
    { locationX : XY
    , locationY : XY
    , size : Pixels
    }


model : Model
model =
    init 0 0 50


init : Int -> Int -> Int -> Model
init x y size =
    { locationX = x
    , locationY = y
    , size = size
    }



-- UPDATE


type Msg
    = Resize Size
    | ShiftX String
    | ShiftY String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Resize size ->
            let
                s =
                    Result.withDefault 1 (String.toInt size)
            in
                { model | size = s }

        ShiftX position ->
            let
                p =
                    Result.withDefault 1 (String.toInt position)
            in
                { model | locationX = p }

        ShiftY position ->
            let
                p =
                    Result.withDefault 1 (String.toInt position)
            in
                { model | locationY = p }



-- VIEW


testView : Model -> Html Msg
testView model =
    div [ Html.Attributes.style [ ( "border", "solid" ) ] ]
        [ viewPort model
        , h2 [] [ Html.text "size" ]
        , input [ placeholder (toString model.size), onInput Resize ] []
        , h2 [] [ Html.text "column" ]
        , input [ placeholder (toString model.locationX), onInput ShiftX ] []
        , h2 [] [ Html.text "row" ]
        , input [ placeholder (toString model.locationY), onInput ShiftY ] []
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
        , square model
        ]


view : Model -> Svg Msg
view model =
    square model


square : Model -> Svg a
square model =
    rect
        [ stroke "brown"
        , fill "beige"
        , x (shiftX model)
        , y (shiftY model)
        , width (toString (model.size - 2))
        , height (toString (model.size - 2))
        , rx "4"
        , ry "4"
        ]
        []


shiftX : Model -> String
shiftX model =
    let
        x =
            model.locationX

        size =
            model.size
    in
        toString (x * size + 1)


shiftY : Model -> String
shiftY model =
    let
        y =
            model.locationY

        size =
            model.size
    in
        toString (y * size)
