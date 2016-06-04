module Position exposing (Model, Msg, init, subscriptions, update, view, Role(..))

import Html exposing (Html, div, span)
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
import Matrix exposing (Location)
import Time exposing (Time, second)


-- CONSTANTS


lightBrown =
  "peru"


darkBrown =
  "saddlebrown"


edgeThickness =
  3



-- MODEL


type alias PieceNumber =
  Int


type alias Pixels =
  Float


type Role
  = Head
  | Link
  | Tail


type PositionType
  = Perimeter
  | Grid
  | Piece Role PieceNumber


type alias Model =
  { location : Location
  , sideSize : Pixels
  , positionType : PositionType
  }


init : ( Model, Cmd Msg )
init =
  let
    model =
      { positionType = Piece Head 43
      , location = ( 1, 1 )
      , sideSize = 1000
      }
  in
    ( model, Cmd.none )



-- UPDATE


type Msg
  = Tick Time
  | Nothing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Tick newTime ->
      ( model, Cmd.none )

    Nothing ->
      ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick



-- VIEW


renderEmptySquare : Pixels -> PositionType -> Html Msg
renderEmptySquare sideSize positionType =
  let
    role =
      Nothing

    pieceNumber =
      0

    fillColor =
      case positionType of
        Grid ->
          "wheat"

        Perimeter ->
          "white"

        Piece role pieceNumber ->
          "white"

    -- doesn't matter
    myStrokeWidth =
      toString (sideSize / 10)

    whole =
      toString sideSize

    rectangle =
      rect
        [ width whole
        , height whole
        , fill fillColor
        , stroke darkBrown
        , strokeWidth myStrokeWidth
        ]
        []
  in
    Svg.svg
      [ version "1.1"
      , x whole
      , y whole
      , viewBox ("0 0 " ++ whole ++ " " ++ whole)
      ]
      [ rectangle
      ]


renderPiece : Pixels -> Role -> PieceNumber -> Html Msg
renderPiece sideSize role pieceNumber =
  let
    plusIndent =
      toString edgeThickness

    minusIndent =
      toString (100 - edgeThickness)

    whole =
      toString sideSize

    half =
      toString (sideSize / 2)

    narrow =
      toString (sideSize / 10)

    polyPoints =
      half
        ++ " "
        ++ plusIndent
        ++ ", "
        ++ minusIndent
        ++ " "
        ++ half
        ++ ", "
        ++ half
        ++ " "
        ++ minusIndent
        ++ ", "
        ++ plusIndent
        ++ " "
        ++ half

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
        [ width whole
        , height whole
        , fill "wheat"
        , stroke darkBrown
        , strokeWidth narrow
        ]
        []

    myText =
      text'
        [ x half
        , y half
        , fill "black"
        , fontSize "48"
        , alignmentBaseline "middle"
        , textAnchor "middle"
        ]
        [ text "99" ]
  in
    Svg.svg
      [ version "1.1"
      , x whole
      , y whole
      , viewBox ("0 0 " ++ whole ++ " " ++ whole)
      ]
      [ rectangle
      , polys
      , myText
      ]


view : Model -> Html Msg
view model =
  let
    positionType =
      model.positionType
  in
    case positionType of
      Grid ->
        renderEmptySquare model.sideSize Grid

      Perimeter ->
        renderEmptySquare model.sideSize Perimeter

      Piece role pieceNumber ->
        renderPiece model.sideSize role pieceNumber
