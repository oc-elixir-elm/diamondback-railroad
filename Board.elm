module Board where

-- import Effects exposing (Effects)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Position
import Matrix
import Maybe exposing (..)


type alias Model =
    { Matrix Position
    }

{-
init : Model
init =
  let
    (left, leftFx) = Square.init
    (right, rightFx) = Square.init
  in
    ( Model left right
    , Effects.batch
        [ Effects.map Left leftFx
        , Effects.map Right rightFx
        ]
    )
-}

pixelsAcross = 50

init : Model
init =
  { Matrix.square 5 (\location -> Position.createGrid  location.col location.row )

  }

-- UPDATE

type Action
    = Left Square.Action
    | Right Square.Action
    | MoveBoth



update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Left act ->
      let
        (left, fx) = Square.update act model.left
      in
        ( Model left model.right
        , Effects.map Left fx
        )

    Right act ->
      let
        (right, fx) = Square.update act model.right
      in
        ( Model model.left right
        , Effects.map Right fx
        )

    MoveBoth ->
      let
        (left, leftFx) = Square.startTranslate model.left
        (right, rightFx) = Square.startTranslate model.right
      in
        ( Model left right
        , Effects.batch
            [Effects.map Left leftFx
            , Effects.map Right rightFx
            ]
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
    [ Square.view (Signal.forwardTo address Left) model.left
    , Square.view (Signal.forwardTo address Right) model.right
    , button [ onClick address MoveBoth ] [ text "Right" ]
    ]
