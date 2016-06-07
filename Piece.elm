module Piece exposing (Model, init, update, view)

import Color


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
import Matrix exposing (Location)
import Time exposing (Time, second, millisecond)


-- MODEL


type alias Pixels =
    Float


type alias PieceNumber =
    Int


type Role
    = Head
    | Middle
    | Tail



--  | Piece Role PieceNumber


type alias Model =
    { role : Role
    , location : Location
    , pieceNumber : PieceNumber
    , sideSize : Pixels
    , xTranslation : Float
    , animationState : AnimationState
    }


type alias AnimationState =
    Maybe { prevClockTime : Time, elapsedTime : Time }


init : ( Model, Cmd Msg )
init =
    ( { role = Head
      , location = ( 1, 1 )
      , pieceNumber = 1
      , sideSize = 44
      , xTranslation = 0
      , animationState = Nothing
      }
    , Cmd.none
    )


xTranslation =
    100


duration =
    (500 * millisecond)



-- UPDATE


type Msg
    = XTranslate
    | Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


{-|
    case msg of
        XTranslate ->
            case model.animationState of
                Nothing ->
                    ( model, Cmd.tick Tick )

                Just _ ->
                    ( model, Cmd.none )

        Tick clockTime ->
            let
                newElapsedTime =
                    case model.animationState of
                        Nothing ->
                            0

                        Just { elapsedTime, prevClockTime } ->
                            elapsedTime + (clockTime - prevClockTime)
            in
                if newElapsedTime > duration then
                    ( { xTranslation = model.xTranslation + xTranslation
                      , animationState = Nothing
                      }
                    , Cmd.none
                    )
                else
                    ( { xTranslation = model.xTranslation
                      , animationState = Just { elapsedTime = newElapsedTime, prevClockTime = clockTime }
                      }
                    , Cmd.tick Tick
                    )


startTranslate : Model -> ( Model, Cmd Msg )
startTranslate model =
    update XTranslate model



-- VIEW


toOffset : AnimationState -> Float
toOffset animationState =
    case animationState of
        Nothing ->
            0

        Just { elapsedTime } ->
            ease easeOutQuint float 0 xTranslation duration elapsedTime

-}



{-
   The secret here is that the collage area is very slightly smaller
   than the graphics "form" piece that fits in it.  The reason is that
   the piece is not moved from one part of the collage's area to another.
   Rather the illusion of a piece moving happens by moving the form
   into the collage's view.  Hence, during transition, part of the form's
   visibility is clipped by it falling outside the collage's area.

   We still want the effect of two diamond forms sliding along each other's edge
   when they are going around a corner.  Hence, a diamond cannot be defined to
   exist within the collage; rather it must be slightly larger.  This means that,
   by itself, the corners of the diamond visually may be slightly clipped.

   This also implies that the rectangle defining the always-present square can be
   rendered to be the border of the collage area.  Since the caller will keep
   the collages adjacent to each other, the inner edges will will show a border
   of twice the thickness of a single collage.  Of course the outside edges will
   only be "half-width" which, while not affecting the game, would "look funny".
   This is solved by the border which provides an outside frame around the game.

   Hence, the TransactSquare will always have a "thick enough" border on all sides
   whether it is a perimeter square or a gold square.  Since the square is
   positioned in the window externally, the required state is minimal:

   * Perimeter: Since there is a frame around the perimeter, the border is
     "thick enough" in all locations.
   * Grid: Since there is a perimeter, the border is uniform within all grid
     squares.  These squares are rendered in a different background color
     than the perimeter squares.

   All empty squares will be visually defined by the above states.

   Now, this can be entirely debugged in isolation from module SequenceGame
   as proposed in the documentation for the Elm Architecture.  See
   "Example 3: A dynamic list of counters" for how SequenceGame can hold
   the additional ID for Square so that Square doesn't have
   to know about its own position.

   In summary, we gain the following advantages:

   * Since TrnaslateSquares don't move, then Elm can leverage its magic
     in quickly updating squares that have changed only.
   * The TranslationSquare, now that it doesn't move, can be tested in
     isolation from the SequenceGame.
   * Hence, the names for the two classes simplify:
     * "TranslationSquare" becomes simply "Square".
     * "SequenceGame becomes simply "Board" or "Game".
-}


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
                [ fill "lightBrown"
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


{-|
view : Signal.Address Msg -> Model -> Html
view address model =
    let
        xTranslation =
            model.xTranslation + toOffset model.animationState

        lPiece =
            ngon 4 50
                |> filled lightBrown
                |> moveX -100
                |> moveX xTranslation

        piece =
            ngon 4 50
                |> filled lightBrown
                |> moveX xTranslation
    in
        [ lPiece, piece ]
            |> collage 100 100
            |> Html.fromElement
-}
view : Model -> Html Msg
view model =
    renderPiece model
