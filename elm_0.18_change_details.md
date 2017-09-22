# Summary

The API for the animation package changed significantly from Elm 0.17 to Elm 0.18.

This document is an effort to document the details.

## Imports

### Adding Imports 

* Animation

### Removing Imports

* AnimationFrame
* Style
* Style.Properties

## Model

* Old State Type: `Style.Animation`
* New State Type: `Animation.State`

## Init

* Old State Assignment: `Style.init []`
* New State Assignment: `Animation.style []`

**Note:** Same for `initWithInfo`

## Subscription

* Old Subscription: `AnimationFrame.times Animate`
* New Subscription: `Animation.subscription Animate <| [model.svgStyle]`

## Update

Several changes here.

### `Animate time ->`:

Old:

```elm
( { model
    | svgStyle = Style.tick time model.svgStyle
  }
, Cmd.none
)
```

---

New:

```elm
( onStyle model <|
    Animation.update time
, Cmd.none
)
```

where

```elm
onStyle : Model -> (Animation.State -> Animation.State) -> Model
onStyle model styleFn =
    { model | svgStyle = styleFn <| model.svgStyle }
```

### `Move Location ->`

Old:

```elm
let
    newModel =
        moveLoc location model

    newModel2 =
        { newModel
            | svgStyle =
                Style.animate
                    |> Style.to (getSvgValues newModel)
                    |> Style.on (setSvgStyle model)
        }
in
    ( newModel2, Cmd.none )
```

---

New:

```elm
( onStyle model <|
     Animation.interrupt
        [ Animation.to
            [ Animation.translate ]
        ]
, Cmd.none
)
```
