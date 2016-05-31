module Position exposing (Model, Msg, init, subscriptions, update, view)

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


type Role
  = Head
  | Link
  | Tail


type Square
  = Perimeter
  | Grid
  | Piece Role PieceNumber


type alias Model =
  { square : Square, location : Location, pieceNumber : PieceNumber }


init : Location -> ( Model, Cmd Msg )
init loc =
  let
    model =   { square = Grid, location = loc, pieceNumber = 81 }
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


renderEmptySquare : Square -> Html Msg
renderEmptySquare square =
  let
    rectangle =
      rect
        [ width "100"
        , height "100"
        , fill "wheat"
        , stroke darkBrown
        , strokeWidth "5"
        ]
        []
  in
    Svg.svg
      [ version "1.1"
      , x "100"
      , y "100"
      , viewBox "0 0 100 100"
      ]
      [ rectangle
      ]


renderPiece : Role -> PieceNumber -> Html Msg
renderPiece role pieceNumber =
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
    Svg.svg
      [ version "1.1"
      , x "100"
      , y "100"
      , viewBox "0 0 100 100"
      ]
      [ rectangle
      , polys
      , myText
      ]


view : Model -> Html Msg
view model =
  let
    square =
      model.square
  in
    case square of
      Grid ->
        renderEmptySquare Grid

      Perimeter ->
        renderEmptySquare Perimeter

      Piece pieceLook pieceNumber ->
        renderPiece pieceLook pieceNumber
