module Game exposing (..)

import Effects exposing (Effects)
import Html
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Window
import Board
import ControlPanel
import Sequence


type alias WindowWidth =
    Int


type alias WindowHeight =
    Int


type alias Model =
    ( WindowWidth, WindowHeight, Board, Sequence )



-- Will have to add Board below


init : ( Model, Effects Action )
init =
    ( Window.width
    , Window.height
    , Sequence.init
    )
