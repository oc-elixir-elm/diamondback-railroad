module Sequence (Model, Action, init) where


type alias Role = Grid | Perimeter

type alias Model =
    { Role
    , Position
    }
