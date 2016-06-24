module Position
    exposing
        ( Model
        , Msg(..)
        , init
        , initWithInfo
        , subscriptions
        , update
        , view
        , PositionType(..)
        , renderEmptySquare
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
import Debug exposing (log)


-- CONSTANTS


lightBrown : String
lightBrown =
    "peru"


darkBrown : String
darkBrown =
    "saddlebrown"



-- MODEL


type alias Pixels =
    Float


type alias WalkedOn =
    Bool


type PositionType
    = Perimeter
    | Grid


type alias Model =
    { location : Location
    , maxPosLength : Int
    , sideSize : Pixels
    , positionType : PositionType
    , walkedOn : WalkedOn
    }


init : ( Model, Cmd Msg )
init =
    let
        model =
            { positionType = Grid
            , maxPosLength = 11
            , location = ( 1, 1 )
            , sideSize = 50
            , walkedOn = False
            }
    in
        ( model, Cmd.none )


initWithInfo : PositionType -> Int -> Pixels -> Location -> ( Model, Cmd Msg )
initWithInfo positionType maxPosLength sideSize location =
    let
        ( model, cmd ) =
            init
    in
        ( { model
            | positionType = positionType
            , maxPosLength = maxPosLength
            , sideSize = sideSize
            , location = location
          }
        , cmd
        )



-- UPDATE


type Msg
    = MarkTraversal
    | Tick Time
    | Nothing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MarkTraversal ->
            let
                newModel =
                    { model
                        | walkedOn =
                            True
                    }
            in
                ( newModel, Cmd.none )

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
        sideSize =
            model.sideSize

        role =
            Nothing

        fillColor =
            case model.positionType of
                Grid ->
                    "wheat"

                Perimeter ->
                    "white"

        -- doesn't matter
        myStrokeWidth =
            toString (model.sideSize / 10)

        boardSize =
            (toFloat model.maxPosLength) * model.sideSize

        ( locX, locY ) =
            model.location

        pixelsX =
            toString (sideSize * (toFloat locX))

        pixelsY =
            toString (sideSize * (toFloat locY))

        whole =
            toString model.sideSize

        rectangle =
            rect
                [ width whole
                , height whole
                , fill fillColor
                , stroke (borderColor model.walkedOn)
                , strokeWidth myStrokeWidth
                ]
                []
    in
        Svg.svg
            [ version "1.1"
            , x pixelsX
            , y pixelsY
            ]
            [ rectangle
            ]


borderColor : Bool -> String
borderColor footPrint =
    if footPrint then
        "black"
    else
        darkBrown


view : Model -> Html Msg
view model =
    renderEmptySquare model
