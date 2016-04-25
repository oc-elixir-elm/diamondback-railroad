module SequenceGame where

import Effects exposing (Effects)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import TranslateSquare

--import Matrix exposing (..)
--import Maybe exposing (..)

-- MODEL

type alias Model =
    { left : TranslateSquare.Model
    , right : TranslateSquare.Model
    }

--type alias GameMap = Matrix Cell

--type alias PieceId = Int

--type alias Piece = (PieceId, Location, Parent)


--type alias Parent = (Location Direction)

init : (Model, Effects Action)
init =
  let
    (left, leftFx) = TranslateSquare.init
    (right, rightFx) = TranslateSquare.init
  in
    ( Model left right
    , Effects.batch
        [ Effects.map Left leftFx
        , Effects.map Right rightFx
        ]
    )


-- UPDATE

type Action
    = Left TranslateSquare.Action
    | Right TranslateSquare.Action
    | MoveRight



update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Left act ->
      let
        (left, fx) = TranslateSquare.update act model.left
      in
        ( Model left model.right
        , Effects.map Left fx
        )

    Right act ->
      let
        (right, fx) = TranslateSquare.update act model.right
      in
        ( Model model.left right
        , Effects.map Right fx
        )

    MoveRight ->
      let
        (right, fx) = TranslateSquare.startTranslate model.right
      in
        ( Model model.left right
        , Effects.map Right fx
        )


-- VIEW


(=>) = (,)

       {-
type Direction = MoveLeft | MoveUp |  MoveRight | MoveDown

moves : Signal.Mailbox Direction
moves = Signal.mailbox MoveLeft
-}

view : Signal.Address Action -> Model -> Html
view address model =
  div [ style [ "display" => "flex" ] ]
    [ TranslateSquare.view (Signal.forwardTo address Left) model.left
    , TranslateSquare.view (Signal.forwardTo address Right) model.right
    , button [ onClick address MoveRight ] [ text "Right" ]
    ]
