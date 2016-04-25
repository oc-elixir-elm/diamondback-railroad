module TranslateSquare (Model, Action, init, update, updateRight, view) where

import Color exposing (lightBrown)
import Easing exposing (ease, easeOutElastic, float)
import Effects exposing (Effects)
import Html exposing (Html)
import Svg exposing (svg, rect, polygon, g, text, text')
import Svg.Attributes exposing (..)
import Svg.Events exposing (onClick)
import Time exposing (Time, second)
import Graphics.Collage exposing (ngon, collage, filled, toForm)


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


updateRight : Model -> (Model, Effects Action)
updateRight model =
  update XTranslate model


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
    {-}
    Html.fromElement (collage 200 200 [
      filled lightBrown (ngon 4 50)
    ])
    -}
    svg
      [ width "200", height "200", viewBox "0 0 300 300" ]
      [ g [ transform ("translate(100, 100) translate(" ++ toString xTranslation ++ ", 0)")
          , onClick (Signal.message address XTranslate)
          ]
          [
             polygon
               [ fill "#F0AD00",
                 points "0,-50 50,0 0,50 -50,0"
               ]
               [],
             text' [ fill "white", textAnchor "middle" ] [ text "*" ]
          ]
      ]
