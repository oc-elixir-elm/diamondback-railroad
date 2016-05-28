module MainPosition exposing (main)

import Html exposing (Html, Attribute, div, text)
import Html.Attributes exposing (style)
import Html.App as Html
import Matrix exposing (Location)
import Position exposing (init, subscriptions, update, view)


-- Hold the SVG graphic in an HTML element


myDivStyle : Attribute msg
myDivStyle =
  Html.Attributes.style
    [ ( "width", "100px" )
    , ( "height", "100px" )
      --    , ( "position", "absolute" )
      --    , ( "left", "0px" )
      --    , ( "top", "0px" )
      --    , ( "backgroundColor", "red" )
    ]


parentView : Position.Model -> Html Position.Msg
parentView model =
  div
    [ myDivStyle
    ]
    [ Position.view model
    ]


main =
  let
    model =
      init ( 1, 1 )
  in
    Html.program
      { init = init ( 1, 1 )
      , view = parentView
      , update = update
      , subscriptions = subscriptions
      }
