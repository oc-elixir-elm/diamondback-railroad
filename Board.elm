module Board exposing (..)


-- import Effects exposing (Effects)

import Graphics.Element exposing (..)


-- import Html exposing (..)
-- import Html.Attributes exposing (..)
-- import Html.Events exposing (onClick)

import Position
import Matrix exposing (..)
import Maybe exposing (..)
import Color exposing (Color, lightBrown, darkBrown)


-- UPDATE
-- Noting in UPDATE yet until we get seqeunce in
-- VIEW


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
  (Matrix Position
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


createMatrix : PosCount -> BoardSideInPixels -> Matrix Element
createMatrix posCount boardSideInPixels =
  let
    posSideInPixels =
      boardSideInPixels // maxPosLength
  in
    Matrix.square posCount (\location -> Position.view posSideInPixels borderColor fillColor)


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


view : ( Int, Int ) -> Element
view ( w, h ) =
  let
    boardWithBorder =
      smallestEdgeInPixels ( w, h )

    boardMatrix =
      createMatrix maxPosLength (boardWithBorder - (2 * borderThickness))

    myBoard =
      makeBoardView boardMatrix
        |> container boardWithBorder boardWithBorder middle
  in
    color borderColor myBoard
