module Position
    exposing
        ( Model
        , Msg
        , init
        , initWithInfo
        , subscriptions
        , update
        , view
        , Role(..)
        , PositionType(..)
        , renderEmptySquare
        , PieceNumber
        )

import Html exposing (Html, div, span)


--import Html.Attributes exposing (style)

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


-- import Color exposing (..)

import Matrix exposing (Location)
import Time exposing (Time, second)


-- CONSTANTS


lightBrown : String
lightBrown =
    "peru"


darkBrown : String
darkBrown =
    "saddlebrown"


edgeThickness : number
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
    , maxPosLength : Int
    , sideSize : Pixels
    , positionType : PositionType
    , pieceNumber : PieceNumber
    }


init : ( Model, Cmd Msg )
init =
    let
        model =
            { positionType = Piece Head 43
            , maxPosLength = 11
            , location = ( 1, 1 )
            , sideSize = 50
            , pieceNumber = 43
            }
    in
        ( model, Cmd.none )


initWithInfo : PositionType -> Int -> Pixels -> Location -> PieceNumber -> ( Model, Cmd Msg )
initWithInfo positionType maxPosLength sideSize location pieceNumber =
    let
        ( model, cmd ) =
            init

        ( locX, locY ) =
            location
    in
        ( { model
            | positionType = positionType
            , maxPosLength = maxPosLength
            , sideSize = sideSize
            , location = location
            , positionType = Piece Head pieceNumber
            , pieceNumber = pieceNumber
          }
        , cmd
        )



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


renderEmptySquare : Model -> Html Msg
renderEmptySquare model =
    let
        role =
            Nothing

        pieceNumber =
            0

        fillColor =
            case model.positionType of
                Grid ->
                    "wheat"

                Perimeter ->
                    "white"

                Piece role pieceNumber ->
                    "white"

        -- doesn't matter
        myStrokeWidth =
            toString (model.sideSize / 10)

        boardSize =
            (toFloat model.maxPosLength) * model.sideSize

        whole =
            toString model.sideSize

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


renderPiece : Model -> Html Msg
renderPiece model =
    let
        sideSize =
            model.sideSize

        ( locX, locY ) =
            model.location

        pixelsX =
            toString (sideSize * (toFloat locX))

        pixelsY =
            toString (sideSize * (toFloat locY))

        edgeRatio =
            (edgeThickness * sideSize) / 100

        plusIndent =
            toString edgeRatio

        minusIndent =
            toString (sideSize - edgeRatio)

        whole =
            toString sideSize

        half =
            toString (sideSize / 2.0)

        narrow =
            toString (sideSize / 10.0)

        textDownMore =
            toString (sideSize / 1.8)

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
                , strokeWidth (toString edgeRatio)
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
                , y textDownMore
                , fill "black"
                , fontSize half
                , alignmentBaseline "middle"
                , textAnchor "middle"
                ]
                [ text (toString model.pieceNumber) ]
    in
        Svg.svg
            [ version "1.1"
            , x pixelsX
            , y pixelsY
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
                renderEmptySquare model

            Perimeter ->
                renderEmptySquare model

            Piece role pieceNumber ->
                renderPiece model
