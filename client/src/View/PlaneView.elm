module View.PlaneView exposing (view)

import Html exposing (Html, div, text, form, label, input, small)
import Html.Attributes exposing (id, class, for, property)
import Json.Encode as Encode

import Models exposing (Model)
import View.Navigator exposing (navbar)
import View.Container exposing (embed)

view : Model -> Html msg
view model =
  div [ id "plane-view" ]
    [ navbar
    , planeForm model |> embed
    ]

planeForm : Model -> Html msg
planeForm model =
  form []
    [ div [ class "form-group row"]
        [ div [ class "col-form-label col-sm-2 col-4" ]
            [ label [ for "plane-radius" ] [ text "radius" ] ]
        , div [ class "col-sm-4 col-8" ]
            [ input
                [ id "plane-radius"
                , class "form-control mx-m-3"
                , property "aria-describedby" (Encode.string "help-plane-radius")
                , property "type" (Encode.string "text")
                ] []
            ]
        , div [ class "col-form-label col-sm-6 col-12" ]
            [ small [ id "help-plane-radius", class "text-muted" ]
                [ text "The creation radius" ]
            ]
        ]
    ]
