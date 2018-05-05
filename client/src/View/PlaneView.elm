module View.PlaneView exposing (view)

import Html exposing (Html, div, text)

import Models exposing (Model)
import View.Navigator exposing (navbar)

view : Model -> Html msg
view model =
  div [] [ navbar, text "Plane" ]