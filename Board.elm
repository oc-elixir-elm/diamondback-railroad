module Board where

-- import Effects exposing (Effects)
import Graphics.Element exposing (..)
-- import Html exposing (..)
-- import Html.Attributes exposing (..)
-- import Html.Events exposing (onClick)
import Position
import Matrix exposing (..)
import Maybe exposing (..)
import Color exposing (lightBrown, darkBrown)


-- UPDATE

-- Noting in UPDATE yet until we get seqeunce in

-- VIEW
type alias PosCount = Int
type alias BoardSideInPixels = Int
type alias Width = Int
type alias Height = Int
type alias Dimensions = { width : Int, height : Int }

maxPosLength : Int
maxPosLength = 11

windowSizePixels : Int
windowSizePixels = 770


createMatrix : Int  -> Matrix Element
createMatrix size  =
  Matrix.square size (\location -> Position.view size lightBrown darkBrown)


{- No need for this until we have dynamically resizeing windows
calculatePosSideInPixels : MaxPosLength -> Window -> Int
calculatePosSideInPixels maxPosLength window =
-}


-- Something to start with:
dimensions : Dimensions
dimensions = { width = windowSizePixels, height = windowSizePixels }


smallestEdgeInPixels : Dimensions -> Int
smallestEdgeInPixels dimensions =
  if dimensions.width > dimensions.height then dimensions.height else dimensions.width


makeBoardView : Matrix Element -> Element
makeBoardView matrix =
  let
    rows = Matrix.toList matrix
    viewRows = List.map (Graphics.Element.flow right rows)
  in
    List.map Graphics.Element.flow down viewRows


view : Element
view =
  let
    boardSideInPixels = smallestEdgeInPixels dimensions
    posSideInPixels = boardSideInPixels // maxPosLength
    boardMatrix = createMatrix posSideInPixels
  in
    makeBoardView boardMatrix
