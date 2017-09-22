module Game exposing (..)

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
    ( WindowWidth, WindowHeight, Board.Model, Sequence.Model )


-- Don't know what messages we're going to have yet
type Msg
    = PlaceHolder


-- Will have to add Board below


init : ( Model, Cmd Msg )
init =
    ( Window.width
    , Window.height
    , Board.init
    , Sequence.init
    )

