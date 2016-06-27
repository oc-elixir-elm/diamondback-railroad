module Piece
    exposing
        ( Model
        , Msg(..)
        , init
        , initWithInfo
        , update
        , view
        )

-- import Easing exposing (ease, easeOutQuint, float)
-- import Effects exposing (Effects)

import Html exposing (Html)
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
import Color
import AnimationFrame
import Matrix exposing (Location)
import Time exposing (Time, second, millisecond)
import Style
import Style.Properties exposing (..)
import Debug exposing (log)


-- MODEL


type alias Pixels =
    Float


type alias PieceNumber =
    Int


type Role
    = Head
    | Middle
    | Tail
    | Unassigned


type alias Model =
    { role : Role
    , location : Location
    , pieceNumber : PieceNumber
    , sideSize : Pixels
    , svgStyle : Style.Animation
    }


init : ( Model, Cmd Msg )
init =
    ( { role = Unassigned
      , location = ( 1, 1 )
      , pieceNumber = 1
      , sideSize = 44
      , svgStyle =
            Style.init []
      }
    , Cmd.none
    )


initWithInfo : PieceNumber -> Pixels -> Location -> ( Model, Cmd Msg )
initWithInfo pieceNumber sideSize location =
    let
        m =
            { role = Unassigned
            , location = location
            , pieceNumber = pieceNumber
            , sideSize = sideSize
            , svgStyle = Style.init []
            }

        model =
            { m | svgStyle = (setSvgStyle m) }
    in
        ( model
        , Cmd.none
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        dummy =
            log "subscriptions" model.location
    in
        AnimationFrame.times Animate



-- UPDATE


type Msg
    = Show
    | Animate Time
    | Move Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Show ->
            ( model, Cmd.none )

        Animate time ->
            ( { model
                | svgStyle = Style.tick time model.svgStyle
              }
            , Cmd.none
            )

        Move location ->
            let
                newModel =
                    moveLoc location model

                newModel2 =
                    { newModel
                        | svgStyle =
                            Style.animate
                                |> Style.to (getSvgValues newModel)
                                |> Style.on (setSvgStyle model)
                    }
            in
                ( newModel2, Cmd.none )


moveLoc : Location -> Model -> Model
moveLoc delta model =
    let
        ( dx, dy ) =
            delta

        ( x, y ) =
            model.location

        newLocation =
            ( x + dx, y + dy )
    in
        { model | location = newLocation }


getSvgValues : Model -> List (Property Float a)
getSvgValues model =
    let
        ( xloc, yloc ) =
            model.location

        pixelsX =
            model.sideSize * (toFloat xloc)

        pixelsY =
            model.sideSize * (toFloat yloc)
    in
        [ X pixelsX
        , Y pixelsY
        ]


setSvgStyle : Model -> Style.Animation
setSvgStyle model =
    Style.init (getSvgValues model)



-- VIEW


edgeThickness : number
edgeThickness =
    3


darkBrown : String
darkBrown =
    "saddlebrown"


renderPiece : Model -> Html Msg
renderPiece model =
    let
        sideSize =
            model.sideSize

        ( locX, locY ) =
            model.location

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
                [ fill "white"
                , points polyPoints
                , stroke "indianred"
                , strokeWidth (toString edgeRatio)
                ]
                []

        myText =
            text'
                [ x half
                , y textDownMore
                , fill "black"
                , fontSize "20"
                , alignmentBaseline "middle"
                , textAnchor "middle"
                ]
                [ text (toString model.pieceNumber) ]

        svgStyle =
            setSvgStyle model
    in
        Svg.svg (Style.renderAttr model.svgStyle)
                [ polys
                , myText
                ]



view : Model -> Html Msg
view model =
    renderPiece model
