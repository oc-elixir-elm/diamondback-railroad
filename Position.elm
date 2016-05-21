module Position exposing (init, subscriptions, update, view)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Svg exposing (..)
import Svg.Attributes
  exposing
    ( alignmentBaseline
    , fill
    , fontSize
    , height
    , points
    , stroke
    , strokeWidth
    , textAnchor
    , version
    , viewBox
    , width
    , x
    , y
    )
import Color exposing (..)
import Matrix exposing (Location, loc)
import Time exposing (Time, second)


-- CONSTANTS


lightBrown =
  "peru"


darkBrown =
  "saddlebrown"


edgeThickness =
  3



-- MODEL


type Role
  = Head
  | Link
  | Tail


type Square
  = Perimeter
  | Grid
  | Piece Role


type alias Model =
  ( Square, Location )


init : ( Model, Cmd Msg )
init =
  let
    square =
      Grid

    location =
      loc 1 1
  in
    ( ( square, location ), Cmd.none )



-- UPDATE


type Msg
  = Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Tick newTime ->
      ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick



-- VIEW


myDivStyle : Attribute msg
myDivStyle =
  Html.Attributes.style
    [ ( "width", "100px" )
    , ( "height", "100px" )
      -- , ( "position", "absolute" )
    , ( "left", "0px" )
    , ( "top", "0px" )
    , ( "backgroundColor", "red" )
    ]


view : Model -> Html Msg
view model =
  let
    plusIndent =
      toString edgeThickness

    minusIndent =
      toString (100 - edgeThickness)

    polyPoints =
      "50 "
        ++ plusIndent
        ++ ", "
        ++ minusIndent
        ++ " 50, 50 "
        ++ minusIndent
        ++ ", "
        ++ plusIndent
        ++ " 50"

    polys =
      polygon
        [ fill lightBrown
        , points polyPoints
        , stroke "indianred"
        , strokeWidth (toString edgeThickness)
        ]
        []

    rectangle =
      rect
        [ width "100"
        , height "100"
        , fill "wheat"
        , stroke darkBrown
        , strokeWidth "5"
        ]
        []

    myText =
      text'
        [ x "50"
        , y "50"
        , fill "black"
        , fontSize "48"
        , alignmentBaseline "middle"
        , textAnchor "middle"
        ]
        [ text "99" ]
  in
    div
      [ myDivStyle
      ]
      [ Svg.svg
          [ version "1.1"
          , Svg.Attributes.width "100"
          , Svg.Attributes.height "100"
          , viewBox "0 0 100 100"
          ]
          [ rectangle
          , polys
          , myText
          ]
      ]
