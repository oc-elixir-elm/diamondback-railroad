module Game where

import Effects exposing (Effects)
import Matrix
import Html
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Sequence
import Position
import Window
import Board

type alias WindowWidth = Int
type alias WindowHeight = Int

type alias Model =
  { WindowWidth
  , WindowHeight
  , Matrix Position
  , Sequence
  }


init : (Model, Effects Action)
init =
  { Window.width
  , Window.height
  ,
