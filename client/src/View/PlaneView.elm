module View.PlaneView exposing (view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (id)

import Models exposing (Model)
import View.Navigator exposing (navbar)

view : Model -> Html msg
view model =
  div [ id "plane-view" ] [ navbar, text "Plane" ]
