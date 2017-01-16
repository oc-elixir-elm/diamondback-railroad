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
import Time exposing (second)
import Animation exposing (px)
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
    initWithInfo 1 44.0 ( 1, 1 )


initWithInfo : PieceNumber -> Pixels -> Location -> ( Model, Cmd Msg )
initWithInfo pieceNumber_ sideSize_ location_ =
    let
        ( pixelsX, pixelsY ) =
            locToPixels location_ sideSize_

        initialStyle =
            Animation.style
                [ Animation.left (px pixelsX)
                , Animation.top (px pixelsY)
                ]
    in
        ( { role = Unassigned
          , location = location_
          , pieceNumber = pieceNumber_
          , sideSize = sideSize_
          , style = initialStyle
          }
        , Cmd.none
        )



--animatePiece : Model -> Animation.Msg -> Animation.State
--animatePiece piece time =
--    let
--        msg =
--            Animate time
--
--        ( newPiece, _ ) =
--            update msg piece
--    in
--        newPiece


-- UPDATE


type Msg
    = Move Location
    | Show
    | Animate Animation.Msg


--onStyle : Model -> (Animation.State -> Animation.State) -> Model
--onStyle model styleFn =
--    { model | styles = styleFn <| model.styles }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Show ->
            ( model, Cmd.none )

        Animate time ->
            ( { model
                | style = Animation.update time model.style
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
                (   { model
                        | location =
                            newLocation

                        , style =
                            (Animation.interrupt
                                [ Animation.to
                                    [ Animation.left
                                        (px newPixelsX)
                                    , Animation.top
                                        (px newPixelsY)
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
                [ fill "white"
                , points polyPoints
                , stroke "indianred"
                , strokeWidth (toString edgeRatio)
                ]
                []

        myText =
            text_
                [ x half
                , y textDownMore
                , fill "black"
                , fontSize "20"
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
        <|
            [ Svg.svg (Animation.render model.style)
--            [ Svg.svg []
                [ polys
                , myText
                ]
            ]


view : Model -> Html Msg
view model =
    renderPiece model
