module Board exposing (init, view, update, subscriptions)

-- import Effects exposing (Effects)
-- import Graphics.Element exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


-- import Html.Events exposing (onClick)

import Position
import Matrix exposing (Matrix)
import Maybe exposing (..)
import Color exposing (Color, lightBrown, darkBrown)
import Time exposing (Time, second)


-- UPDATE

update : Msg -> Model -> Model
update msg model =
    model

-- VIEW
-- Number of positions on the side of the boafd


type alias PosCount =
  Int


type alias BoardSideInPixels =
  Int


type alias Width =
  Int


type alias Height =
  Int


type alias Dimensions =
  ( Width, Height )


type alias Model =
  (Matrix Position.Model
   -- I'm sure something will need to be added.
  )


maxPosLength : PosCount
maxPosLength =
  11


borderColor : Color
borderColor =
  darkBrown


fillColor : Color
fillColor =
  lightBrown


borderThickness : Int
borderThickness =
  10

createMatrix : PosCount -> BoardSideInPixels -> Matrix Html
createMatrix posCount boardSideInPixels =
  let
    posSideInPixels =
      boardSideInPixels // maxPosLength
  in
    -- Matrix.square posCount (\location -> Position.view posSideInPixels borderColor fillColor)
    Matrix.square posCount ((text " square") posSideInPixels borderColor fillColor)


{-
smallestEdgeInPixels : Dimensions -> Int
smallestEdgeInPixels ( x, y ) =
  if x > y then
    y
  else
    x


makeBoardView : Matrix Element -> Element
makeBoardView matrix =
  let
    rows =
      Matrix.toList matrix

    viewRows =
      List.map (Graphics.Element.flow right) rows
  in
    Graphics.Element.flow down viewRows
-}


render_rows =
  text " square"

init : (Model, Cmd Msg)
init =
    (createMatrix maxPosLength (boardWithBorder - (2 * borderThickness)), Cmd.none)

type Msg
  = Tick Time

view : Model -> Html Msg
view model =
{-
  let
    boardWithBorder =
      smallestEdgeInPixels ( w, h )

    boardMatrix =
      createMatrix maxPosLength (boardWithBorder - (2 * borderThickness))

    myBoard =
      makeBoardView boardMatrix
        |> container boardWithBorder boardWithBorder middle

  in
    --    color borderColor myBoard
-}
  let
    rows =
      Matrix.toList matrix
  in
    List.map rows render_rows
{-
    div []
      [ div []
          [ span []
              [ text "square" ]
          , span []
              [ text "square" ]
          ]
      , div []
          [ span []
              [ text "square" ]
          , span []
              [ text "square" ]
          ]
      ]
-}