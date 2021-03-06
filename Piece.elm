module Piece
    exposing
        ( Model
        , Msg(..)
        , init
        , initWithInfo
        , update
        , view
        )

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
import Time exposing (second)
import Animation
import Matrix exposing (Location)
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
    , style : Animation.State
    }


init : ( Model, Cmd Msg )
init =
    initWithInfo 1 0.0 ( 1, 1 )


initWithInfo : PieceNumber -> Pixels -> Location -> ( Model, Cmd Msg )
initWithInfo pieceNumber_ sideSize_ location_ =
    let
        ( pixelsX, pixelsY ) =
            locToPixels location_ sideSize_

-- A fluid 'cornering action' animation:
        initialStyle =
            Animation.style
                [ Animation.x pixelsX
                , Animation.y pixelsY
                ]
-- Offers a harsher 'moving-within-the-squares' animation:
--            Animation.styleWith (Animation.easing
--                { duration = 0.2 * Time.second
--                , ease = (\x -> sqrt x)
--                })
--                [ Animation.x pixelsX
--                , Animation.y pixelsY
--                ]
    in
        ( { role = Unassigned
          , location = location_
          , pieceNumber = pieceNumber_
          , sideSize = sideSize_
          , style = initialStyle
          }
        , Cmd.none
        )


-- UPDATE


type Msg
    = Move Location
    | Animate Animation.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Animate time ->
            ( { model
                | style = log "style" (Animation.update time model.style)
              }
            , Cmd.none
            )

        Move location ->
            let
                newLocation =
                    newLoc location model

                ( newPixelsX, newPixelsY ) =
                    locToPixels
                        newLocation
                        model.sideSize
            in
                ( { model
                    | location =
                        newLocation
                    , style =
                        (Animation.interrupt
                            [ Animation.to
                                [ Animation.x
                                    newPixelsX
                                , Animation.y
                                    newPixelsY
                                ]
                            ]
                            model.style
                        )
                  }
                , Cmd.none
                )


newLoc : Location -> Model -> Location
newLoc delta model =
    let
        ( dx, dy ) =
            delta

        ( x, y ) =
            model.location
    in
        ( x + dx, y + dy )


locToPixels : Location -> Float -> ( Pixels, Pixels )
locToPixels location sideSize =
    let
        ( xloc, yloc ) =
            location

        pixelsX =
            sideSize * (toFloat xloc)

        pixelsY =
            sideSize * (toFloat yloc)
    in
        ( pixelsX, pixelsY )



-- VIEW


edgeThickness : Float
edgeThickness =
    5.4545455


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
            sideSize * 0.01

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

        fontSize_ =
            toString (round (sideSize * 0.5))

        textDownMore =
            toString (sideSize / 1.8)

        polyPoints =
            half
                ++ ","
                ++ plusIndent
                ++ " "
                ++ minusIndent
                ++ ","
                ++ half
                ++ " "
                ++ half
                ++ ","
                ++ minusIndent
                ++ " "
                ++ plusIndent
                ++ ","
                ++ half

        polys =
            polygon
                [ fill "white"
                , points polyPoints
                , stroke "indianred"
                , strokeWidth (toString edgeThickness)
                ]
                []

        myText =
            text_
                [ x half
                , y textDownMore
                , fill "black"
                , fontSize fontSize_
                , alignmentBaseline "middle"
                , textAnchor "middle"
                ]
                [ text (toString model.pieceNumber) ]
    in
        Svg.svg
            (Animation.render model.style
                ++ [ version "1.1"
                   ]
            )
            [ polys
            , myText
            ]


view : Model -> Html Msg
view model =
    renderPiece model
