module MainWindow exposing (..)

import Html exposing (Html, div, text)
import Task
import Window


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { windowSize : Window.Size
    }


init : ( Model, Cmd Msg )
init =
    ( { windowSize =
            Window.Size 0 0
      }
    , Task.perform Resize Window.size -- update size for initial display
    )


type Msg
    = Resize Window.Size
    | Idle


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resize newSize ->
            ( { model
                | windowSize = newSize
              }
            , Cmd.none
            )

        Idle ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Window.resizes Resize


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ text
                ("Width: "
                    ++ toString model.windowSize.width
                )
            ]
        , div []
            [ text
                ("Height: "
                    ++ toString model.windowSize.height
                )
            ]
        ]



--module Main exposing (..)
--
--import Graphics.Element exposing (..)
--import Window
--
--
--main : Signal Element
--main =
--    Signal.map view Window.dimensions
--
--
--view : ( Int, Int ) -> Element
--view ( w, h ) =
--    container w h middle (show (toString ( w, h )))
