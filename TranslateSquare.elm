module TranslateSquare (Model, Action, init, update, view) where

import Easing exposing (ease, easeOutElastic, float)
import Effects exposing (Effects)
import Html exposing (Html)
import Svg exposing (svg, rect, g, text, text')
import Svg.Attributes exposing (..)
import Svg.Events exposing (onClick)
import Time exposing (Time, second)


-- MODEL

type alias Model =
    { xTranslation : Float
    , animationState : AnimationState
    }


type alias AnimationState =
    Maybe { prevClockTime : Time, elapsedTime : Time }


init : (Model, Effects Action)
init =
  ( { xTranslation = 0, animationState = Nothing }
  , Effects.none
  )


xTranslation = 100
duration = second



-- UPDATE

type Action
    = XTranslate
    | Tick Time


update : Action -> Model -> (Model, Effects Action)
update msg model =
  case msg of
    XTranslate ->
      case model.animationState of
        Nothing ->
          ( model, Effects.tick Tick )

        Just _ ->
          ( model, Effects.none )

    Tick clockTime ->
      let
        newElapsedTime =
          case model.animationState of
            Nothing ->
              0

            Just {elapsedTime, prevClockTime} ->
              elapsedTime + (clockTime - prevClockTime)
      in
        if newElapsedTime > duration then
          ( { xTranslation = model.xTranslation + xTranslation
            , animationState = Nothing
            }
          , Effects.none
          )
        else
          ( { xTranslation = model.xTranslation
            , animationState = Just { elapsedTime = newElapsedTime, prevClockTime = clockTime }
            }
          , Effects.tick Tick
          )


-- VIEW

toOffset : AnimationState -> Float
toOffset animationState =
  case animationState of
    Nothing ->
      0

    Just {elapsedTime} ->
      ease easeOutElastic float 0 xTranslation duration elapsedTime


view : Signal.Address Action -> Model -> Html
view address model =
  let
    xTranslation =
      model.xTranslation + toOffset model.animationState
  in
    svg
      [ width "200", height "200", viewBox "0 0 300 300" ]
      [ g [ transform ("translate(100, 100) translate(" ++ toString xTranslation ++ ", 0)")
          , onClick (Signal.message address XTranslate)
          ]
          [ rect
              [ x "-50"
              , y "-50"
              , width "100"
              , height "100"
              , rx "15"
              , ry "15"
              , style "fill: #60B5CC;"
              ]
              []
          , text' [ fill "white", textAnchor "middle" ] [ text "Click me!" ]
          ]
      ]
