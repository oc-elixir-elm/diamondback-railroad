module MainPosition exposing (main)

import Html exposing (Html, Attribute, div, text)
import Html.Attributes exposing (style)
import Matrix exposing (Location)
import Position exposing (init, subscriptions, update, view)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
