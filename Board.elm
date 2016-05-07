module Board where

-- import Effects exposing (Effects)
import Graphics.Elements exposing (..)
-- import Html exposing (..)
-- import Html.Attributes exposing (..)
-- import Html.Events exposing (onClick)
import Position
import Matrix exposing (square)
import Maybe exposing (..)


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

locateGridPosition : Location -> Position
locateGridPosition location =



createMatrix : HorizPosCount -> VertPosCount -> Matrix a
createMatrix horizPosCount vertPosCount =
  square


calculatePosSideInPixels : MaxPosLength -> Window -> Int
calculatePosSideInPixels maxPosLength window =


-- Something to start with:
dimensions : Dimensions
dimensions = { width = 1000, height = 1000 }


smallestEdgeInPixels : Dimensions -> Int
smallestEdgeInPixels dimensions =
  if dimensions.width > dimensions.height then dimensions.height else dimensions.width


view : Element
view =
  let
    boardSideInPixels = smallestEdgeInPixels dimensions
    posSideInPixels = boardSideInPixels / maxPosLength
  in
