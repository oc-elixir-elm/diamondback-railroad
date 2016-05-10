module Board where

-- import Effects exposing (Effects)
import Graphics.Element exposing (..)
-- import Html exposing (..)
-- import Html.Attributes exposing (..)
-- import Html.Events exposing (onClick)
import Position
import Matrix
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

-- locateGridPosition : Location -> Position
-- locateGridPosition location =


{-}
createMatrix : Int  -> Matrix.Matrix Position
createMatrix size  =
  Matrix.square size (\location -> Position.view size lightBrown darkBrown)
-}

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


makeBoardView : Int (Matrix Int)
makeBoardView pixelsSize matrix =




view : Element
view =
  let
    boardSideInPixels = smallestEdgeInPixels dimensions
    posSideInPixels = boardSideInPixels // maxPosLength
    boardMatrix = createMatrix posSideInPixels
    makeBoardView posSideInPixels boardMatrix
  in
